class_name ContagionStateDead
extends ContagionState

var time_dead : int = 0

func enter() -> void:
	time_dead = 0
	crew.is_dead = true
	crew.modulate = Color.gray
	crew.anim.play("dead")

func update() -> String:
	time_dead += 1
	return ""

func state_name() -> String:
	return "death"

func get_factor() -> float:
	match _level():
		0: return .2
		1: return .3
		2: return .5
		_: return .6

func productivity() -> float:
	return 0.0

func is_dead() -> bool:
	return true

func update_crew_aspect() -> void:
	crew.sick_particle.visible = _level() > 0
	crew.heal_particle.visible = false

func _level() -> int:
	if time_dead < 5:
		return 0
	elif time_dead < 12:
		return 1
	elif time_dead < 20:
		return 2
	return 3

func is_infected() -> bool:
	return true

func menus() -> Array:
	return ["move"]
