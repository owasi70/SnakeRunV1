extends Node2D

@export var snake_path: NodePath
@export var food_scene: PackedScene
@export var appearance_frequency: int  
@export var min_spawn_time: float 
@export var max_spawn_time: float 
@export var food_lifetime_delay: float = 2.0
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
	if not is_instance_valid(snake):
		return
	if this_time < next_spawn_time:
		this_time += delta
	else:
		spawn_food()
		this_time = 0
		next_spawn_time = randf_range(min_spawn_time, max_spawn_time)
func spawn_food() -> void:
	if not is_instance_valid(snake):
		return
	var viewport_rect = get_viewport_rect()
	var viewport_width = get_viewport().get_camera_2d().zoom.x * viewport_rect.size.x 
	var lane_count = 5
	var lane_width = viewport_width / lane_count 
	var camera_y = camera.global_position.y if camera else 0
	var spawn_y = camera_y - viewport_rect.size.y / 2 - 50
	if snake:
		spawn_y = snake.global_position.y - lane_width * 2 - 200
	for i in range(-2, 3):  
		if randi() % 100 < appearance_frequency:
			var x = i * lane_width + viewport_width / 2 + randf_range(-lane_width / 3, lane_width / 3)
			var food_instance = food_scene.instantiate()
			food_instance.global_position = Vector2(x, spawn_y)
			food_instance.add_to_group("Food")
			add_child(food_instance)
