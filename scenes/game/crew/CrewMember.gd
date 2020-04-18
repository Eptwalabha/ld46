class_name CrewMember
extends Node2D

export(String) var crew_name = ""
export(bool) var is_infected := false

var thirst := 0
var hunger := 0
var exhaustion := 0
var infected_since := 0
var sleeping := false
var current_task = null
var is_dead := false

func _ready() -> void:
	crew_name = name

func productivity(hour) -> float:
	var pick_productivity = _pick_productivity(hour)
	return pick_productivity

func _pick_productivity(hour: int) -> float:
	if is_dead:
		return 0.0
	if is_infected:
		var day_infected = ceil((hour - infected_since) / 24)
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

func update_crew_state(hour) -> void:
	thirst += 1
	hunger += 1
	if current_task is Task:
		exhaustion += 1

func is_alive() -> bool:
	return not is_dead
