class_name CrewMember
extends Node2D

export(Texture) var texture
export(String) var crew_name = "no name"
export(bool) var positive := false

var efficiency := 1.0
var room_id : String = ""
var current_task = 0
var scheduled_tasks = []
var contagion_detected = false
var is_dead := false

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

func is_infected() -> bool:
	return current_health_state.is_infected()

func update_state(_hour: int) -> void:
	update_protection()
	var next_health_state = current_health_state.update()
	change_state("health", next_health_state)
	var next_activity_state = current_activity_state.update()
	change_state("activity", next_activity_state)
	update_visual_state()
	efficiency = productivity()

func make_a_viral_test() -> void:
	current_health_state.make_a_viral_test()

func update_visual_state() -> void:
	current_health_state.update_crew_aspect()

func work_on(_task) -> void:
	pass

func is_alive() -> bool:
	return not is_dead

func get_health() -> int:
	return 0

func update_protection() -> void:
	pass

func in_contact_with(crew) -> void:
	pass

func in_contaminated_room(room) -> void:
	pass

func get_location_request() -> String:
	if is_alive():
		return current_activity_state.next_location()
	return ""

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

func get_texture() -> Texture:
	return texture
