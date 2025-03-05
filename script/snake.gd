extends RigidBody2D

@export var speed: float = 200.0
@export var sensitivity: float = 10.0
@export var tail_scene: PackedScene
@export var follow_speed: float = 20.0
@export var health : int = 4
@onready var tail_container: Node2D = $tailContainer
@onready var health_label: Label = $healthLabel

var dragging: bool = false
var previous_position: Array = []
var tail_segments: Array = []
var is_colliding_with_box: bool = false
var box: Node = null 

func _ready() -> void:
	update_label()
	for i in range(health):
		add_tail_segment()

func _process(delta: float) -> void:
	position.y -= speed * delta  

	if dragging:
		var touch_pos : Vector2 = get_global_mouse_position()
		var viewport_size = get_viewport_rect().size
		position.x = clamp(touch_pos.x, 0 , viewport_size.x) 
	previous_position.insert(0,position)
	if previous_position.size() > tail_segments.size() + 1:
		previous_position.pop_back()
	for i in range(tail_segments.size()):
		if i + 1 < previous_position.size():
			var target_position = previous_position[i + 1] + Vector2(0, (i + 1) *25)
			tail_segments[i].global_position = tail_segments[i].global_position.lerp(target_position, follow_speed * delta)

func _physics_process(delta: float) -> void:
	if not dragging:  # Move only if not dragging
		linear_velocity = Vector2(0, speed)  # Move upwards
	else:
		linear_velocity = Vector2.ZERO  
func add_tail_segment() -> void:
	var tail = tail_scene.instantiate()
	call_deferred("add_tail_to_container", tail)

func add_tail_to_container(tail) -> void:
	tail_container.add_child(tail)
	tail_segments.append(tail)

func increase_length(amount: int) -> void:
	health += amount
	update_label()
	for i in range(amount):
		add_tail_segment()

func decrease_length(amount: int) -> void:
	health -= amount
	update_label()
	for i in range(amount):
		if tail_segments.size() > 0:
			var tail = tail_segments.pop_front()
			tail.queue_free()
	if health <= 0:
		game_over()

func update_label() -> void:
	health_label.text = str(health)

func game_over() -> void:
	print("Game Over!")
	queue_free()


func _on_touch_screen_button_pressed() -> void:
	dragging = true


func _on_touch_screen_button_released() -> void:
	dragging = false
