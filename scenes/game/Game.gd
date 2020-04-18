class_name Game
extends Node

onready var ui := $GameUI as GameUI
onready var ship := $Ship as Ship

var ongoing_task = []

var hour : int = 0

func next_event() -> void:
	var new_events = []
	while new_events.size() == 0:
		next_hour()
		yield(get_tree().create_timer(.5), "timeout")
		if hour % 10 == 0:
			new_events.push_back("super")

func next_hour() -> void:
	hour += 1
	ui.update_ui(hour)
	print("hour %s" % hour)
	update_crew_state()
	update_ongoing_tasks()
	check_ship_state()
	spawn_random_events()

func update_daily_tasks() -> Array:
	return []

func update_ongoing_tasks() -> void:
	for task in ongoing_task:
		if task is Task:
			task.update_task(hour)

func update_crew_state() -> void:
	var crew_members = ship.get_crew_members()
	for crew in crew_members:
		crew.update_crew_state(hour)

func check_ship_state() -> void:
	pass

func spawn_random_events() -> void:
	pass

func _on_Task_completed(task: Task) -> void:
	pass

func _on_Task_failed(task: Task) -> void:
	pass

func _on_GameUI_next_event_clicked() -> void:
	next_event()

func _on_GameUI_next_hour_clicked() -> void:
	next_hour()
