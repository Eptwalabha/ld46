class_name RoomStateCleaning
extends RoomState

var time_left = 10

func enter() -> void:
	time_left = 10

func update_state() -> String:
	time_left -= 1
	if time_left < 0:
		return "cleaned"
	return ""

func update_visual() -> void:
	room.modulate = Color.blue

func is_contaminated() -> bool:
	return room.contaminated

func get_contamination_factor() -> float:
	return 0.2 if is_contaminated() else 0.0

func contaminated_by_crew(crew) -> void:
	pass

func is_available() -> bool:
	return false

func state_name() -> String:
	return "cleaning"
