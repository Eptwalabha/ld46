class_name Game
extends Node

onready var ui := $GameUI as GameUI
onready var ship := $Ship as Ship

var ongoing_task = []

var hour : int = 0
var ua : float = 0.0
var ua_goal := 30 # neptune
var until_next_event := false

func _ready() -> void:
	$GameUI.setup($Ship)

func next_event() -> void:
	var new_events = []
	until_next_event = true
	var fail_safe = hour + 10
	while new_events.size() == 0 and until_next_event:
		new_events = next_hour()
		yield(get_tree().create_timer(.2), "timeout")
		if hour >= fail_safe:
			new_events.push_back("super")
	until_next_event = false
	ui.next_event_over()

func next_hour() -> Array:
	hour += 1
	ui.update_ui(hour)
	update_crew_state()
	update_ongoing_tasks()
	update_ship_state()
	check_ship_state()
	spawn_random_events()
	return []

func update_ongoing_tasks() -> void:
	for task in ongoing_task:
		if task is Task:
			task.update_task(hour)

func update_ship_state() -> void:
	ship.update_covered_distance()

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

func _on_GameUI_next_event_toggled(button_pressed) -> void:
	if until_next_event and not button_pressed:
		until_next_event = false
	elif button_pressed:
		next_event()

func _on_GameUI_next_hour_clicked() -> void:
	next_hour()
