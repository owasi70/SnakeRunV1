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
var queue_free_delay: float = 0.5
var blocks_to_remove = [] 
func _ready() -> void:
	if snake_path:
		snake = get_node(snake_path)
	next_spawn_time = randf_range(min_spawn_time, max_spawn_time)
	previous_snake_pos = snake.global_position if is_instance_valid(snake) else Vector2.ZERO
	spawn_row()

func _process(delta: float) -> void:
	if is_instance_valid(snake):
		if this_time < next_spawn_time:
			this_time += delta
		else:
			# Decide whether to spawn full row or random number of blocks
			var full_row_chance = randi() % 2 == 0  
			if full_row_chance:
				spawn_row(5) 
			else:
				spawn_row((randi() % 5) + 1) 
			this_time = 0
			next_spawn_time = randf_range(min_spawn_time, max_spawn_time)
	else:
		# If snake is no longer in the scene, stop spawning
		this_time = 0
		next_spawn_time = 0

func spawn_row(block_number: int = 5) -> void:
	if is_instance_valid(snake):
		var lanes = []
		for i in range(block_number):
			var lane_number = randi() % 5
			while lane_number in lanes:
				lane_number = randi() % 5
			lanes.append(lane_number)
			# Use the snake's position to spawn blocks
			var spawn_y = snake.global_position.y - min_spawn_dist
			spawn_blocks(lane_number, spawn_y)

func spawn_blocks(lane_number, spawn_y) -> void:
	# Get the width of the viewport (screen width)
	var viewport_width = get_viewport_rect().size.x
	var lane_width = viewport_width / 5
	# Calculate the x position based on the lane number
	var x = (lane_number * lane_width) + lane_width / 2 
	var spawn_pos = Vector2(x, spawn_y)
	# Ensure blocks are not duplicated
	if spawn_pos not in existing_blocks:
		var box_instance = box_scene.instantiate()
		box_instance.global_position = spawn_pos
		add_child(box_instance)
		existing_blocks.append(spawn_pos)

func _physics_process(_delta: float) -> void:
	if is_instance_valid(snake):
		# Remove blocks that have moved off the screen
		for child in get_children():
			if child.is_in_group("Box") and child.global_position.y > snake.global_position.y + get_viewport_rect().size.y:
				child.queue_free()
				existing_blocks.erase(child.global_position)
	else:
		# Snake is no longer in the scene, remove all blocks with a delay
		# Track blocks that need to be removed
		for child in get_children():
			if child.is_in_group("Box"):
				blocks_to_remove.append(child)
