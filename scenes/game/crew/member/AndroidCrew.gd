class_name AndroidCrew
extends CrewMember

var need_maintenance := false
var in_maintenance := false
var last_maintenance := 0
var hours_before_next_maintenance := 100

func _ready() -> void:
	states = {
		"health": {
			"healthy": "ContagionStates/Healthy",
			"contaminated": "ContagionStates/Contaminated",
		},
		"activity": {
			"idle": "ActivityStates/Idle",
			"working": "ActivityStates/AndroidWorking",
			"maintenance": "ActivityStates/Maintenance",
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

func productivity() -> float:
	return current_activity_state.productivity()

func exposed_to_virus(factor: float) -> void:
	current_health_state.exposed_to_virus(factor)

