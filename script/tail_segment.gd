extends Node2D

var target_position: Vector2
var follow_speed: float = 8.0  
var slowed_speed: float = 3.0  
var is_slowed: bool = false

func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Box"):
		is_slowed = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Box"):
		is_slowed = false
