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
	change_state("health", "healthy")
	change_state("activity", "idle")

func work_on(task) -> void:
	current_activity_state.work_on(task)

func update_state(_hour: int) -> void:
	var next_health_state = current_health_state.update()
	change_state("health", next_health_state)
	var next_activity_state = current_activity_state.update()
	change_state("activity", next_activity_state)
	efficiency = productivity()

func is_human() -> bool:
	return false

func is_corrupted() -> bool:
	return corruption_level > 0

func corruption_level() -> int:
	return corruption_level

func productivity() -> float:
	return current_activity_state.productivity()

func exposed_to_virus(factor: float) -> void:
	current_health_state.exposed_to_virus(factor)

