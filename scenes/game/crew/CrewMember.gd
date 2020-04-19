class_name CrewMember
extends Node2D

signal crew_state_update

export(String) var crew_name = "no name"
export(bool) var is_infected := false

var thirst := 0
var hunger := 0
var exhaustion := 0
var infected_since := 0
var sleeping := false
var is_dead := false
var efficiency := 1.0
var location : String = ""
var task_count = 0
var current_task = 0

var current_activity_state
var current_mental_state
var current_health_state

func productivity() -> float:
	return 1.0

func is_human() -> bool:
	return true

func infectiousness() -> float:
	return current_health_state.get_factor()

func update_state(hour: int) -> void:
	current_health_state.update()
	thirst += 1
	hunger += 1
	efficiency = productivity()
	emit_signal("crew_state_update")

func work_on(task) -> void:
	if is_dead:
		return
	current_task = task.task_id
	exhaustion += 1
	task.worked_on(crew_name, efficiency)

func is_alive() -> bool:
	return true

func get_health() -> int:
	return 0

func exposed_to_virus(factor: float) -> void:
	pass

func change_contagion_state(new_state) -> void:
	new_state.enter()
	current_health_state = new_state
