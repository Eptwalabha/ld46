class_name Task
extends Node

signal task_completed
signal task_failed(task)
signal task_updated

export(int) var start_in := 0
export(float, .2) var hour_cost := 1.0
export(int) var time_before_fail := 100
export(int) var max_crew := 3
export(String) var title := "a task"
export(String) var description := "description"
export(NodePath) var room := null

var hour_spent := 0.0
var task_since := 0
var task_id : int = 0
var location : String = ""

func _init() -> void:
	task_id = GameData.get_id()

func update_task(hour) -> void:
	if hour - task_since > time_before_fail:
		emit_signal("task_failed", self)
	emit_signal("task_updated")

func worked_on(hour: float) -> void:
	hour_spent += hour
	if hour_spent >= hour_cost:
		emit_signal("task_completed")
	emit_signal("task_updated")

func penalty(_ship: Ship) -> void:
	pass

func is_active() -> bool:
	return true
