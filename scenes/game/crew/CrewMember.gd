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

func productivity(hour: int) -> float:
	var pick_productivity = _pick_productivity(hour)
	return pick_productivity

func is_human() -> bool:
	return true

func _pick_productivity(hour: int) -> float:
	if is_dead:
		return 0.0
	if is_infected:
		var day_infected = ceil((hour - infected_since) / 24.0)
		match day_infected:
			1: return 1.0
			2: return .9
			3: return .7
			4: return .3
			_: return .2
	else:
		return 1.0

func infectiousness(hour) -> float:
	if is_dead:
		return 1.0
	if is_infected:
		var day_infected = ceil((hour - infected_since) / 24)
		match day_infected:
			1: return 0.0
			2: return .3
			3: return .7
			4: return 1.0
			_: return 1.0
	else:
		return 0.0

func update_state(hour: int) -> void:
	if is_dead:
		return
	thirst += 1
	hunger += 1
	efficiency = productivity(hour)
	emit_signal("crew_state_update")

func work_on(task) -> void:
	if is_dead:
		return
	current_task = task.task_id
	exhaustion += 1
	task.worked_on(crew_name, efficiency)

func is_alive() -> bool:
	return not is_dead

func get_health() -> int:
	return 0
