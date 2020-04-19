class_name Game
extends Node

var TaskResource = load("res://scenes/game/gameplay/tasks/Task.tscn")
var TASK_STATE = preload("res://script/game_enum.gd").TASK_STATE

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
	var t : Task = TaskResource.instance()
	t.title = "super new task lol"
	t.time_to_complete = 5
	t.is_daily = true
	t.on_complete = {
		"ship-max-speed": +.2,
		"ship-speed": +.2
	}
	tasks[t.task_id] = t
	var t2 : Task = TaskResource.instance()
	t2.title = "other super task"
	t2.description = "[bold]super[/bold]\nit works"
	t2.time_to_complete = 10
	t2.expires = true
	t2.expires_after = 2
	t2.on_failure = {
		"ship-speed": -.1,
		"ship-max-speed": -.1,
		"food": -2,
		"water": -3
	}
	t2.max_crew = 5
	tasks[t2.task_id] = t2

	for crew in ship.get_crew_members():
		var crew_name = crew.crew_name
		crew_members[crew_name] = crew
		schedule[crew_name] = []
	assign_crew_to_task(t.task_id, ["jack", "hal"])
	assign_crew_to_task(t2.task_id, ["jack", "hal", "dave"])
	update_task_and_crew_count()
	$GameUI.set_tasks([t, t2])
	$GameUI.refresh(0)

func get_assigned_crew(task_id: int) -> Array:
	var assigned_crew_members = []
	for crew_name in crew_members:
		if schedule[crew_name].has(task_id):
			assigned_crew_members.push_back(crew_members[crew_name])
	return assigned_crew_members

func get_task(task_id: int) -> Task:
	return tasks[task_id]

func get_crew_members() -> Array:
	return crew_members

func assign_crew_to_task(task_id, crew_to_assign) -> void:
	if not tasks.has(task_id):
		return

	for crew_name in schedule:
		var crew_tasks = schedule[crew_name]
		var is_one_assigned = crew_to_assign.has(crew_name)
		var has_already_this_task = crew_tasks.has(task_id)
		if is_one_assigned and not has_already_this_task:
			schedule[crew_name].push_back(task_id)
		elif not is_one_assigned and has_already_this_task:
			schedule[crew_name].remove(crew_tasks.find(task_id))

	tasks[task_id].crew_count = crew_to_assign.size()

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
	# tasks timer
	for task_id in tasks:
		tasks[task_id].update_task(hour)

	# for each task scheduled
	for crew_name in schedule:
		if schedule[crew_name].size() == 0:
			continue
		var crew = crew_members[crew_name]
		for i in range(schedule[crew_name].size()):
			var task_id = schedule[crew_name][i]
			var task = tasks[task_id]
			if task.state == TASK_STATE.ONGOING and crew.location == task.location:
				crew.work_on(task)
				break

	for task_id in tasks:
		var task = tasks[task_id]
		if task.is_active():
			continue
		match task.state:
			TASK_STATE.COMPLETE:
				apply_task_effect(task)
			TASK_STATE.EXPIRED:
				apply_task_effect(task)
			_: pass
		
		if task.state == TASK_STATE.DONE:
			for crew_name in schedule:
				if schedule[crew_name].size() == 0:
					continue
	
	update_task_and_crew_count()

func update_task_and_crew_count() -> void:
	var counter = {}
	for crew_name in schedule:
		crew_members[crew_name].task_count = schedule[crew_name].size()
		for task_id in schedule[crew_name]:
			if counter.has(task_id):
				counter[task_id] += 1
			else:
				counter[task_id] = 1
	for task_id in tasks:
		var c = 0 if not counter.has(task_id) else counter[task_id]
		tasks[task_id].crew_count = c


func apply_task_effect(task: Task) -> void:
	var effects = task.get_effect()
	for effect_key in effects:
		var data = effects[effect_key]
		match effect_key:
			"ship-speed": ship.change_speed(data)
			"ship-max-speed": ship.change_max_speed(data)
			"ship-water": ship.change_water(data)
			"ship-food": ship.change_food(data)
			"room-contamination-level":
				var nbr = data
				if nbr > 0:
					pass
				else:
					pass
			_: pass

	task.end_task(hour)
	var m = schedule.keys()
	if task.state != TASK_STATE.DONE:
		m = task.crew_who_worked_on_it
	for crew_name in m:
		var i = schedule[crew_name].find(task.task_id)
		if i != -1:
			schedule[crew_name].remove(i)

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
