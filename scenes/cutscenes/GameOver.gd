extends Node

func _on_replay_pressed() -> void:
	var _err = get_tree().change_scene("res://scenes/game/Game.tscn")
