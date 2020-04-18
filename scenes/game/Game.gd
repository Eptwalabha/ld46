class_name Game
extends Node

var TaskResource = load("res://scenes/game/gameplay/tasks/Task.tscn")

onready var ui := $GameUI as GameUI
onready var ship := $Ship as Ship

var ongoing_task = []
var hour : int = 0
var ua : float = 0.0
var ua_goal := 30 # neptune
var until_next_event := false


func _ready() -> void:
	$GameUI.set_ship(ship)
	var t : Task = TaskResource.instance()
	t.title = "super new task lol"
	var crew = ship.get_crew_members()
	t.crew_assigned = [crew[0], crew[1]]
	t.hour_cost = 5
	crew[0].tasks = [t]
	crew[1].tasks = [t]
	$GameUI.set_tasks([t])

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
	for crew in ship.get_crew_members():
		crew.work(hour)

func update_ship_state() -> void:
	ship.update_covered_distance()

func update_crew_state() -> void:
	for crew in ship.get_crew_members():
		crew.update_crew_state(hour)

func check_ship_state() -> void:
	pass

func spawn_random_events() -> void:
	pass

func _on_Task_completed(_task: Task) -> void:
	pass

func _on_Task_failed(_task: Task) -> void:
	pass

func _on_GameUI_next_event_toggled(button_pressed) -> void:
	if until_next_event and not button_pressed:
		until_next_event = false
	elif button_pressed:
		next_event()

func _on_GameUI_next_hour_clicked() -> void:
	var _events = next_hour()
