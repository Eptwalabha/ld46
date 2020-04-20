class_name Task
extends Node

signal task_completed
signal task_expired(task_id)

export(int) var start_at := 0
export(float, .2) var time_to_complete := 1.0
export(bool) var expires := false
export(bool) var repeat_once_complete := false
export(int) var expires_after := 99999
export(Dictionary) var success := {}
export(Dictionary) var failure := {}
export(int) var cooldown := 0

export(int) var max_crew := 3

export(String) var title := "a task"
export(String) var description := "description"
export(NodePath) var room := null

var active := true
var hour_spent := 0.0
var task_since := 0
var task_id : int = 0
var room_name : String = ""
var crew_count := 0
var state := 0
var TASK_STATE = preload("res://script/game_enum.gd").TASK_STATE

var crew_who_worked_on_it = []
var assigned_crew = []

func _init() -> void:
	state = TASK_STATE.SCHEDULED
	task_id = GameData.get_id()

func update_task(hour) -> void:
	if is_active():
		if hour > start_at:
			state = TASK_STATE.ONGOING
			if expires and hour > start_at + expires_after:
				state = TASK_STATE.EXPIRED
				emit_signal("task_expired", [task_id])

func worked_on(crew_name: String, hour: float) -> void:
	if not crew_who_worked_on_it.has(crew_name):
		crew_who_worked_on_it.push_back(crew_name)
	hour_spent += hour
	if hour_spent >= time_to_complete:
		state = TASK_STATE.COMPLETE
		emit_signal("task_completed")

func is_active() -> bool:
	return state == TASK_STATE.SCHEDULED or state == TASK_STATE.ONGOING

func get_effect() -> Dictionary:
	if not is_active():
		match state:
			TASK_STATE.COMPLETE:
				return success
			TASK_STATE.EXPIRED:
				return failure
	return {}

func end_task(hour: int) -> void:
	if repeat_once_complete:
		state = TASK_STATE.ONGOING
		start_at = hour + cooldown
		hour_spent = 0.0
	else:
		state = TASK_STATE.DONE

func build_from_data(data: Dictionary) -> void:
	var fields = [
		"title", "description",
		"time_to_complete", "expires", "repeat_once_complete",
		"expires_after", "success", "failure",
		"cooldown", "max_crew"
	]

	for field in fields:
		if data.has(field):
			self[field] = data[field]
