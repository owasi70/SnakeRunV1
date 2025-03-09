extends RigidBody2D

@export var speed: float
@export var sensitivity: float
@export var tail_scene: PackedScene
@export var follow_speed: float
@export var health: int = 4
@onready var health_label: Label = $healthLabel
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var removesound: AudioStreamPlayer = $removesound
@onready var eatsound: AudioStreamPlayer = $eatsound
@onready var gameoversound: AudioStreamPlayer = $gameoversound



var previous_position: Array = []
var tail_segments: Array = []
var is_colliding_with_box: bool = false
var touch_pos: Vector2 = Vector2.ZERO
var touch_start: Vector2 = Vector2.ZERO  
var is_dragging = false
var last_drag_position: Vector2 = Vector2.ZERO
var velocity: Vector2
var snake_direction: Vector2 = Vector2(0, -1)  
var health_decrease_timer: float = 0 
var health_decrease_interval: float = 0.1 
var score: int = 0
var last_position: Vector2

func _ready() -> void:
	update_label()
	for i in range(health):
		add_tail_segment()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			is_dragging = true
			last_drag_position = event.position
		else:
			is_dragging = false
	

	elif event is InputEventScreenDrag and is_dragging:
		var delta_x = event.position.x - last_drag_position.x
		position.x += delta_x * sensitivity
		var viewport_size = get_viewport_rect().size
		position.x = clamp(position.x, 0, viewport_size.x)
		touch_pos.x = position.x
		last_drag_position = event.position

func _physics_process(delta: float) -> void:
	if not is_colliding_with_box:
		position.y += snake_direction.y * speed * delta 
	var distance_covered = position.distance_to(last_position)
	score += int((distance_covered * 0.01 )/ 10)  
	SignalManager.On_Score_Update.emit(score)
	var overlapping_bodies = get_colliding_bodies()
	var collided_with_box = false
	for body in overlapping_bodies:
		if body is Box:
			collided_with_box = true
			health_decrease_timer -= delta
			if health_decrease_timer <= 0:
				health_decrease_timer = health_decrease_interval  
				body.decrease_health(1)
				decrease_length(1)

	if collided_with_box:
		is_colliding_with_box = true
	else:
		is_colliding_with_box = false


	if is_colliding_with_box:
		gpu_particles_2d.emitting = true
	else:
		gpu_particles_2d.emitting = false

func _process(delta: float) -> void:
	if touch_pos != Vector2.ZERO:

		var viewport_size = get_viewport_rect().size
		position.x = clamp(touch_pos.x, 0, viewport_size.x) 
		previous_position.insert(0, position)
		if previous_position.size() > tail_segments.size() + 1:
			previous_position.pop_back()
		for i in range(tail_segments.size()):
			if i + 1 < previous_position.size():
				var target_position = previous_position[i + 1] + Vector2(0, (i + 1) * 25)
				tail_segments[i].global_position = tail_segments[i].global_position.lerp(target_position, follow_speed * delta)
	

func add_tail_segment() -> void:
	var tail = tail_scene.instantiate()  
	call_deferred("add_tail_to_snake", tail)  
	tail_segments.append(tail)


func add_tail_to_snake(tail: RigidBody2D) -> void:
	self.add_child(tail)  


func increase_length(amount: int) -> void:
	health += amount
	eatsound.play()
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
			gpu_particles_2d.emitting = true
			removesound.play()
	if health <= 0:
		gameoversound.play()
		game_over()


func update_label() -> void:
	health_label.text = str(health)

# Handles game over
func game_over() -> void:
	print("Game Over!")
	gameoversound.play()  
	GameManager.game_all_over() 
	queue_free() 
