class_name Game
extends Node

var TaskResource = load("res://scenes/game/gameplay/tasks/Task.tscn")

onready var ui := $GameUI as GameUI
onready var ship := $Ship as Ship

var hour : int = 0
var ua : float = 0.0
var ua_goal := 30 # neptune
var until_next_event := false

var tasks = {}
var crew_members = {}
var schedule = {}

func _ready() -> void:
	$GameUI.set_ship(ship)
	for crew in ship.get_crew_members():
		crew_members[crew.crew_name] = crew
	var t : Task = TaskResource.instance()
	t.title = "super new task lol"
	t.hour_cost = 5
	tasks[t.task_id] = t
	schedule["jack"] = [t.task_id]
	schedule["hal"] = [t.task_id]
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
	update_crew()
	update_tasks()
#	update_equipments()
	update_ship()
	spawn_random_events()
	ui.refresh(hour)
	return []

func update_tasks() -> void:
	for task_id in tasks:
		tasks[task_id].update_task(hour)

	for crew_name in schedule:
		if schedule[crew_name].size() == 0:
			continue
		var crew = crew_members[crew_name]
		var task_id = schedule[crew_name][0]
		var task = tasks[task_id]
		if task.is_active() and crew.location == task.location:
			crew.work_on(task)

func update_ship() -> void:
	ship.update_covered_distance()

func update_crew() -> void:
	for crew_id in crew_members:
		crew_members[crew_id].update_state(hour)

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
