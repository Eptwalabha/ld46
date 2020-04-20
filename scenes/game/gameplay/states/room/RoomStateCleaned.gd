class_name RoomStateCleaned
extends RoomState

var contaminated = false

func enter() -> void:
	contaminated = false

func update_state() -> String:
	if is_contaminated():
		return "contaminated"
	return ""

func is_contaminated() -> bool:
	return room.contaminable and contaminated

func get_contamination_factor() -> float:
	return 0.3 if is_contaminated() else 0.0

func visited_by(crew) -> void:
	if not room.contaminable:
		return
	if crew.is_infected():
		contaminated = true

func contaminated_by_crew(crew) -> void:
	if not room.contaminable or contaminated:
		return
	var factor = room.ship.air_filter_efficiency() * crew.infectiousness()
	contaminated = randf() < factor

func update_visual() -> void:
	room.modulate = Color.white

func state_name() -> String:
	return "cleaned"
