extends Control


@onready var score_label: Label = $scoreLabel

var score : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.On_Score_Update.connect(on_score_update)
	SignalManager.On_Health_Update.connect(on_health_update)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_score_update(distance: int)-> void:
	score += distance
	score_label.text = str(score)

func on_health_update(health: int)-> void:
	if health == 0:
		GameManager.game_over()
