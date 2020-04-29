class_name CrewMember
extends Node2D

signal crew_clicked(crew)
signal crew_updated()

onready var sick_particle := $crew/Sick as CPUParticles2D
onready var heal_particle := $crew/Heal as CPUParticles2D
onready var anim := $AnimationPlayer as AnimationPlayer

export(Texture) var portrait
export(String) var crew_name = "no name"
export(bool) var positive := false

var efficiency := 1.0
var room_id : String = ""
var current_task = 0
var scheduled_tasks = []
var is_dead := false
var next_location = null

var tested = false
var is_test_positive = false
var is_visibly_contaminated = false

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
	emit_signal("crew_updated")

func make_a_viral_test() -> void:
	tested = true
	current_health_state.make_a_viral_test()
	is_test_positive = current_health_state.is_infected()
	emit_signal("crew_updated")

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

func in_contact_with(_crew) -> void:
	pass

func in_contaminated_room(_room) -> void:
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

func get_texture() -> Texture:
	return $crew.texture

func contaminated() -> void:
	change_state("health", "sick")

func healed() -> void:
	tested = false
	is_test_positive = false

func is_healing() -> bool:
	return false

func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		emit_signal("crew_clicked", self)

func get_contextual_menus() -> Array:
	return current_health_state.menus()
