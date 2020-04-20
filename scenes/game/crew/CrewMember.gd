class_name CrewMember
extends Node2D

export(String) var crew_name = "no name"
export(bool) var is_infected := false

var efficiency := 1.0
var room_id : String = ""
var current_task = 0
var scheduled_tasks = []
var contagion_detected = false

#var current_mental_state
var current_health_state
var current_activity_state

var states = {
	"health": {},
	"activiy": {},
}

func productivity() -> float:
	return 1.0

func is_human() -> bool:
	return true

func infectiousness() -> float:
	return current_health_state.get_factor()

func update_state(_hour: int) -> void:
	pass

func work_on(_task) -> void:
	pass

func is_alive() -> bool:
	return true

func get_health() -> int:
	return 0

func exposed_to_virus(_factor: float) -> void:
	pass

func get_location_request() -> String:
	return current_activity_state.next_location()

func change_state(type: String, new_state: String) -> void:
	if new_state == "":
		return
	if states[type].has(new_state):
		var new_state_node = states[type][new_state]
		if type == "activity" and new_state_node is ActivityState:
			current_activity_state = new_state_node
			new_state_node.enter()
		elif type == "health" and new_state_node is ContagionState:
			current_health_state = new_state_node
			new_state_node.enter()
	else:
		printerr("WARNING: unknown %s state '%s'" % [type, new_state])

func viral_test() -> bool:
	var is_contamined = current_health_state.is_contaminated()
	if is_contamined:
		contagion_detected = true
	return is_contamined
