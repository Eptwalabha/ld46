class_name HumanCrew
extends CrewMember

export(bool) var wearing_mask := false
var wake_up_since := 0

var thirst := 0
var hunger := 0
var exhaustion := 0

func _ready() -> void:
	states = {
		"health": {
			"healthy": "ContagionStates/Healthy",
			"sick": "ContagionStates/Sick",
			"healed": "ContagionStates/Healed",
			"dead": "ContagionStates/Dead",
		},
		"activity": {
			"no-activity": "ActivityStates/NoActivity",
			"working": "ActivityStates/Working",
			"sleeping": "ActivityStates/Sleeping",
			"healing": "ActivityStates/Healing",
		},
	}
	change_state("health", "healthy")
	change_state("activity", "idle")

func update_state(_hour: int) -> void:
	thirst += 1
	hunger += 1
	wake_up_since += 1
	var next_health_state = current_health_state.update()
	change_state("health", next_health_state)
	var next_activity_state = current_activity_state.update()
	change_state("activity", next_activity_state)
	efficiency = productivity()

func work_on(task) -> void:
	if is_alive():
		current_activity_state.work_on(task)

func productivity() -> float:
	var health_ratio = current_health_state.productivity()
	var activity_productivity = current_activity_state.productivity()
	return (health_ratio + activity_productivity) / 2.0

func exposed_to_virus(factor: float) -> void:
	factor = factor if not wearing_mask else factor / 2.0
	current_health_state.exposed_to_virus(factor)

func infectiousness() -> float:
	var factor = current_health_state.get_factor()
	return factor if not wearing_mask else factor / 2.0

func is_alive() -> bool:
	return current_health_state.is_dead()
