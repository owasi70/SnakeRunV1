extends Camera2D

@export var snake_path: NodePath
var snake: RigidBody2D
var initial_camera_pos: Vector2
var follow_camera: bool = true  
func _ready() -> void:
	initial_camera_pos = global_position
	if snake_path:
		snake = get_node(snake_path)

func _process(delta: float) -> void:
	if is_instance_valid(snake):
		var viewport_size = get_viewport_rect().size
		var target_pos = initial_camera_pos + Vector2(0, snake.global_position.y - viewport_size.y / 1.5)
		global_position = global_position.lerp(target_pos, 0.1)
	else:
		global_position = initial_camera_pos
