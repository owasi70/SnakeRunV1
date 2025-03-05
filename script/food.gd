extends Area2D

@export var value: int = 1
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = randi() % 10 + 1 
	label.text = str(value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y > get_viewport_rect().size.y:
		queue_free()
		print("ququq")


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("increase_length"):
		body.increase_length(value)
		queue_free()
