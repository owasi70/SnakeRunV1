extends Area2D

@export var value: int = 1
@onready var label: Label = $Label
@onready var guava: Sprite2D = $guava
@onready var apple: Sprite2D = $apple
@onready var orange: Sprite2D = $orange
@onready var cake: Sprite2D = $cake
@onready var pizza: Sprite2D = $pizza
@onready var candy: Sprite2D = $candy


func _ready() -> void:
	var random_value = randi() % 6
	match random_value:
		0:
			value = 1
			apple.show()
			guava.hide()
			orange.hide()
			cake.hide()
			pizza.hide()
			candy.hide()
		1:
			value = 2
			apple.hide()
			guava.show()
			orange.hide()
			cake.hide()
			pizza.hide()
			candy.hide()
		2:
			value = 3
			apple.hide()
			guava.hide()
			orange.show()
			cake.hide()
			pizza.hide()
			candy.hide()
		3:
			value = 4
			apple.hide()
			guava.hide()
			orange.hide()
			cake.show()
			pizza.hide()
			candy.hide()
		4:
			value = 5
			apple.hide()
			guava.hide()
			orange.hide()
			cake.hide()
			pizza.show()
			candy.hide()
		5:
			value = 10
			apple.hide()
			guava.hide()
			orange.hide()
			cake.hide()
			pizza.hide()
			candy.show()
	label.text = str(value)


func _process(delta: float) -> void:
	if position.y > get_viewport_rect().size.y:
		queue_free()
		print("ququq")


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("increase_length"):
		body.increase_length(value)
		queue_free()
