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
			"death": $ContagionStates/Dead,
		},
		"activity": {
			"no-activity": $ActivityStates/NoActivity,
			"working": $ActivityStates/Working,
			"sleeping": $ActivityStates/Sleeping,
			"healing": $ActivityStates/Healing,
		},
	}
	var health_state = "healthy" if not positive else "sick"
	change_state("health", health_state)
	change_state("activity", "no-activity")

func update_protection() -> void:
	mask_ttl -= 1
	if mask_ttl < 0:
		mask_ttl = 0

func work_on(task) -> void:
	if is_alive():
		current_activity_state.work_on(task)

func productivity() -> float:
	var health_ratio = current_health_state.productivity()
	var activity_productivity = current_activity_state.productivity()
	return health_ratio * activity_productivity

func in_contact_with(crew) -> void:
	_attempt_at_contamination(crew.infectiousness())

func in_contaminated_room(room) -> void:
	_attempt_at_contamination(room.get_contamination_factor())

func _attempt_at_contamination(factor: float) -> void:
	var reduction = .5 if is_protected() else 1.0
	current_health_state.exposed_to_virus(reduction * factor)

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
