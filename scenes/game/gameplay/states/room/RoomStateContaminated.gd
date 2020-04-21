class_name RoomStateContaminated
extends RoomState

var amount := 5
var sick_crew := 0

func enter() -> void:
	amount = 5
	sick_crew = 0

func update_state() -> String:
	amount += -1 if sick_crew == 0 else sick_crew
	amount = int(clamp(amount, 0, 20))
	sick_crew = 0
	if amount == 0:
		return "cleaned"
	return ""

func update_visual() -> void:
	if amount < 10:
		room.modulate = Color(0.8, 1, 0.8)
	else:
		room.modulate = Color(0.5, 1, 0.5)

func is_contaminated() -> bool:
	return true

func get_contamination_factor() -> float:
	return 0.0

func visited_by(crew) -> void:
	if not room.contaminable:
		return
	if crew.is_infected():
		sick_crew += 1

func contaminated_by_crew(_crew) -> void:
	pass

func state_name() -> String:
	return "contaminated"

