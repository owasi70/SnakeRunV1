extends Control

@onready var start_button: Button = $StartButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var high_score: Label = $VBoxContainer/highScore

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("Startanim")




func _on_start_button_pressed() -> void:
	GameManager.start_game()
