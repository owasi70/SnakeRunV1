extends Node2D

@export var snake_path: NodePath
@export var box_scene: PackedScene
@export var min_spawn_time: float 
@export var max_spawn_time: float 
@export var min_spawn_dist: float 

var snake
var this_time: float = 0.0
var next_spawn_time: float
var previous_snake_pos: Vector2
var existing_blocks = []
var camera

func _ready() -> void:
	if snake_path:
		snake = get_node(snake_path)
	camera = get_viewport().get_camera_2d()
	next_spawn_time = randf_range(min_spawn_time, max_spawn_time)
	previous_snake_pos = snake.global_position if snake else Vector2.ZERO
	spawn_row()

func _process(delta: float) -> void:
	if this_time < next_spawn_time:
		if not snake.is_colliding_with_box:
			this_time += delta
	else:
		var full_row_chance = randi() % 2 == 0  
		if full_row_chance:
			spawn_row(5) 
		else:
			spawn_row((randi() % 5) + 1) 
		this_time = 0
		next_spawn_time = randf_range(min_spawn_time, max_spawn_time)

func spawn_row(block_number: int = 5) -> void:
	var lanes = []
	for i in range(block_number):
		var lane_number = randi() % 5
		while lane_number in lanes:
			lane_number = randi() % 5
		lanes.append(lane_number)
		var spawn_y = snake.global_position.y - min_spawn_dist if snake else camera.global_position.y - get_viewport_rect().size.y / 2 - min_spawn_dist
		spawn_blocks(lane_number, spawn_y)

func spawn_blocks(lane_number, spawn_y) -> void:
	var viewport_size = get_viewport_rect().size
	var screen_width = viewport_size.x
	var lane_width = screen_width / 5
	var x = (lane_number * lane_width) + lane_width / 2 
	var spawn_pos = Vector2(x, spawn_y)
	if spawn_pos not in existing_blocks:
		var box_instance = box_scene.instantiate()
		box_instance.global_position = spawn_pos
		add_child(box_instance)
		existing_blocks.append(spawn_pos)

func _physics_process(_delta: float) -> void:
	if camera:
		var camera_y = camera.global_position.y
		var viewport_height = get_viewport_rect().size.y
		for child in get_children():
			if child.is_in_group("Box") and child.global_position.y > camera_y + viewport_height:
				child.queue_free()
				existing_blocks.erase(child.global_position)
