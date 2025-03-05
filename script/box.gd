extends RigidBody2D

@export var life: int = 10
@export var max_life_for_red: int = 50
@export var dont_move: bool = false
@onready var label: Label = $Label
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D


var snake
var initial_pos: Vector2
var life_for_color: float

func _ready() -> void:
	if is_in_group("Box"):
		life = randi() % 46 + 5 
	else:
		life = randi() % 10 + 1
	life_for_color = life
	label.text = str(life)
	initial_pos = global_position
	set_box_color()
	gravity_scale = 0
	lock_rotation = true
	freeze = true


func _process(delta: float) -> void:
	if dont_move:
		global_position = initial_pos
	if snake and snake.tail_segments.size() > 0:
		if global_position.y - snake.global_position.y < -10:
			queue_free()


func _physics_process(delta: float) -> void:
	if life != life_for_color:
		life_for_color = life
		set_box_color()
		update_text()

func _on_body_entered(body: Node) -> void:
	print(body.name)
	if body.is_in_group("Snake"):
		print(body.name)
		life -= 1
		update_text()
		#gpu_particles_2d.emitting = true
		body.is_colliding_with_box = true
		body.decrease_length(1)
		if life <= 0:
			destroy()


func update_text() -> void:
	label.text = str(life)
func set_box_color() -> void:
	var sprite = $Sprite2D
	var color = Color(1, 1, 1, 1)
	if life_for_color > max_life_for_red:
		color = Color(1, 0, 0, 1) 
	elif life_for_color >= max_life_for_red / 2:
		color = Color(1, 1 - (life_for_color / max_life_for_red), 0, 1) 
	else:
		color = Color(life_for_color / (max_life_for_red / 2), 1, 0, 1)  
	if sprite:
		sprite.modulate = color

func destroy() -> void:
	$Sprite2D.visible = false
	$Label.visible = false
	$CollisionShape2D.disabled = true
	gpu_particles_2d.emitting = true
	
	queue_free()



func _on_body_exited(body: Node) -> void:
	if body.is_in_group("snake"):
		gpu_particles_2d.emitting = false
		body.is_colliding_with_box = false
