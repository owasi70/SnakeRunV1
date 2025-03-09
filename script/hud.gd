extends Control


@onready var score_label: Label = $scoreLabel

var score : int = 0

func _ready() -> void:
	SignalManager.On_Score_Update.connect(on_score_update)


func on_score_update(distance: int)-> void:
	score = distance
	score_label.text = str(score)
	print(score)
