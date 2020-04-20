class_name HumanCrew
extends CrewMember

export(int) var mask_ttl := 0
var wake_up_since := 0

var thirst := 0
var hunger := 0
var exhaustion := 0
var consecutive_hours_of_work := 0

func _ready() -> void:
	states = {
		"health": {
			"healthy": $ContagionStates/Healthy,
			"sick": $ContagionStates/Sick,
			"healed": $ContagionStates/Healed,
			"dead": $ContagionStates/Dead,
		},
		"activity": {
			"no-activity": $ActivityStates/NoActivity,
			"working": $ActivityStates/Working,
			"sleeping": $ActivityStates/Sleeping,
			"healing": $ActivityStates/Healing,
		},
	}
	change_state("health", "healthy")
	change_state("activity", "no-activity")

func update_state(_hour: int) -> void:
	thirst += 1
	hunger += 1
	wake_up_since += 1
	mask_ttl -= 1
	if mask_ttl < 0:
		mask_ttl = 0
	var next_health_state = current_health_state.update()
	change_state("health", next_health_state)
	var next_activity_state = current_activity_state.update()
	change_state("activity", next_activity_state)
	efficiency = productivity()

func work_on(task) -> void:
	if is_alive():
		current_activity_state.work_on(task)

func update_position() -> String:
	return current_activity_state.position()

func productivity() -> float:
	var health_ratio = current_health_state.productivity()
	var activity_productivity = current_activity_state.productivity()
	return health_ratio * activity_productivity

func exposed_to_virus(factor: float) -> void:
	factor /= 2.0 if is_protected() else 1.0
	current_health_state.exposed_to_virus(factor)

func infectiousness() -> float:
	var factor = current_health_state.get_factor()
	return factor / 2.0 if is_protected() else factor

func is_alive() -> bool:
	return not current_health_state.is_dead()

func healed() -> void:
	if is_alive():
		change_state("health", "healed")

func is_protected() -> bool:
	return mask_ttl > 0
