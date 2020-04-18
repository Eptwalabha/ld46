class_name Task
extends Node

signal task_completed
signal task_failed

export(int) var start_in := 0
export(int) var hour_to_complete := 1
export(int) var time_before_fail := 100
export(String) var description := "description"

var task_since := 0

func update_task(hour) -> void:
	if hour - task_since > time_before_fail:
		emit_signal("task_failed")

func worked_on(hour: int) -> void:
	hour_to_complete -= hour
	if hour_to_complete <= 0:
		emit_signal("task_completed")
