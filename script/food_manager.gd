extends Node2D

@export var snake_path: NodePath
@export var food_scene: PackedScene
@export var appearance_frequency: int = 50  
@export var min_spawn_time: float = 3.0
@export var max_spawn_time: float = 5.0

var snake
var this_time: float = 0.0
var next_spawn_time: float
var camera

func _ready() -> void:
	if snake_path:
		snake = get_node(snake_path)
	camera = get_viewport().get_camera_2d()
	next_spawn_time = randf_range(min_spawn_time, max_spawn_time)
	spawn_food()

func _process(delta: float) -> void:
	if this_time < next_spawn_time:
		this_time += delta
	else:
		spawn_food()
		this_time = 0
		next_spawn_time = randf_range(min_spawn_time, max_spawn_time)

func spawn_food() -> void:
	var viewport_rect = get_viewport_rect()
	var viewport_width = viewport_rect.size.x
	var lane_count = 5
	var lane_width = viewport_width / lane_count
	
	var camera_y = camera.global_position.y if camera else 0
	var spawn_y = camera_y - viewport_rect.size.y / 2 - 50
	if snake:
		spawn_y = snake.global_position.y - lane_width * 2 - 200
	for i in range(-2, 3):
		if randi() % 100 < appearance_frequency and randf() > 0.5:
			var x = i * lane_width + viewport_width / 2 + randf_range(-lane_width / 3, lane_width / 3)
			var food_instance = food_scene.instantiate()
			food_instance.global_position = Vector2(x, spawn_y)
			food_instance.add_to_group("Food")
			add_child(food_instance)
func _physics_process(_delta: float) -> void:
	if camera:
		var camera_y = camera.global_position.y
		var viewport_height = get_viewport_rect().size.y
		for child in get_children():
			if child.is_in_group("Food") and child.global_position.y > camera_y + viewport_height:
				child.queue_free()
