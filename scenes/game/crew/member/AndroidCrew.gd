class_name AndroidCrew
extends CrewMember

var hours_before_next_maintenance := 100
var corruption_level := 0

func _ready() -> void:
	states = {
		"health": {
			"healthy": $ContagionStates/Healthy,
			"contaminated": $ContagionStates/Contaminated,
		},
		"activity": {
			"idle": $ActivityStates/Idle,
			"working": $ActivityStates/AndroidWorking,
			"maintenance": $ActivityStates/Maintenance,
			"cleaned": $ActivityStates/Cleaned,
		},
	}
	var health_state = "healthy" if not positive else "contaminated"
	change_state("health", health_state)
	change_state("activity", "idle")

func work_on(task) -> void:
	current_activity_state.work_on(task)

func is_human() -> bool:
	return false

func is_alive() -> bool:
	return true

func is_corrupted() -> bool:
	return corruption_level > 0

func get_corruption_level() -> int:
	return corruption_level

func productivity() -> float:
	return current_activity_state.productivity()

func in_contact_with(crew) -> void:
	_attempt_at_contamination(crew.infectiousness())

func in_contaminated_room(room) -> void:
	_attempt_at_contamination(room.get_contamination_factor())

func _attempt_at_contamination(factor: float) -> void:
	current_health_state.exposed_to_virus(factor)
	
func cleaned() -> void:
	change_state("health", "healthy")
