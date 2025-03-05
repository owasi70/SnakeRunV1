extends Camera2D


@export var snake_path: NodePath 
var snake: RigidBody2D
var initial_camera_pos: Vector2

func _ready() -> void:
	initial_camera_pos = global_position
	if snake_path:
		snake = get_node(snake_path)

func _process(delta: float) -> void:
	# First check if snake reference is valid
	if is_instance_valid(snake):
		# Calculate a position similar to the Unity version
		# Using viewport_size to approximate the orthographicSize concept
		var viewport_size = get_viewport_rect().size
		var target_pos = initial_camera_pos + Vector2(0, snake.global_position.y - viewport_size.y/1.5)
		
		# Use lerp for smooth following
		global_position = global_position.lerp(target_pos, 0.1)
	else:
		# If snake reference is no longer valid, try to get it again
		if snake_path:
			snake = get_node_or_null(snake_path)
