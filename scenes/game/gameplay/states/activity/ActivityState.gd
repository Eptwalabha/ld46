class_name ActivityState
extends Node

var crew

func _ready() -> void:
	crew = get_parent().get_parent()

func update() -> String:
	return ""

func productivity() -> float:
	return 0.0

func work_on(_task) -> void:
	pass
