extends RigidBody2D

class_name Box
@export var life: int 
@export var max_life_for_red: int 
@onready var label: Label = $Label
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var sprite: Sprite2D = $Sprite2D

var snake
var initial_pos: Vector2
var life_for_color: float

func _ready() -> void:
	life = get_random_life()
	life_for_color = life
	label.text = str(life)
	initial_pos = global_position
	set_box_color()

func _process(delta: float) -> void:
	global_position = initial_pos 
	if life <= 0:
		queue_free()


func _physics_process(delta: float) -> void:
	if life != life_for_color:
		life_for_color = life
		set_box_color()
		update_text()

func update_text() -> void:
	label.text = str(max(life, 0))  

func set_box_color() -> void:
	if life <= 15:
		sprite.modulate = Color(0, 1, 0, 1) 
	elif life <= 29:
		sprite.modulate = Color(1, 0.5, 0, 1)  
	else:
		sprite.modulate = Color(1, 0, 0, 1)  


func get_random_life() -> int:
	var rand_value = randf() * 100 
	if rand_value < 70:  
		return randi_range(1, 10)
	elif rand_value < 90:  
		return randi_range(11, 20)
	else:  
		return randi_range(21, 50)

func decrease_health(amount: int) -> void:
	life -= amount
	if life < 0:
		life = 0
	print("Box health: ", life)
