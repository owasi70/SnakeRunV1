extends Node

const MAIN:PackedScene = preload("res://scene/main.tscn")
const STARTMENU:PackedScene = preload("res://scene/start_menu.tscn")

var final_score:int = 0
func start_game():
	get_tree().change_scene_to_packed(MAIN)

func game_all_over():
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(STARTMENU)


func set_final_score(score:int)-> void:
	final_score = score
