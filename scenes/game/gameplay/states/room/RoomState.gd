class_name RoomState
extends Node

var room

func _ready() -> void:
	room = get_parent().get_parent()

func enter() -> void:
	pass

func update_state() -> String:
	return ""

func update_visual() -> void:
	pass

func is_contaminated() -> bool:
	return false

func get_contamination_factor() -> float:
	return 0.0

func visited_by(_crew) -> void:
	pass

func contaminated_by_crew(_crew) -> void:
	pass

func is_available() -> bool:
	return not room.closed

func state_name() -> String:
	return ""
