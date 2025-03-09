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
	# Randomize life based on box type
	life = randi() % 46 + 1
	life_for_color = life
	label.text = str(life)
	initial_pos = global_position
	set_box_color()

func _process(delta: float) -> void:
	global_position = initial_pos  # Keeps box in place if static

	# If life is <= 0, queue the box for removal
	if life <= 0:
		queue_free()


func _physics_process(delta: float) -> void:
	# Update color based on current life
	if life != life_for_color:
		life_for_color = life
		set_box_color()
		update_text()

func update_text() -> void:
	label.text = str(max(life, 0))  # Prevents negative numbers

func set_box_color() -> void:
	var t = life / float(max_life_for_red)
	sprite.modulate = Color(1 - t, t, 0, 1)  # Green to Red transition

func decrease_health(amount: int) -> void:
	life -= amount
	if life < 0:
		life = 0
	print("Box health: ", life)
