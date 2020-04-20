class_name Game
extends Node

var TaskResource = load("res://scenes/game/gameplay/tasks/Task.tscn")
var TASK_STATE = preload("res://script/game_enum.gd").TASK_STATE

onready var ui := $GameUI as GameUI
onready var ship := $Ship as Ship
onready var task_factory := $TaskFactory

var hour : int = 0
var ua : float = 0.0
var ua_goal := 30 # neptune
var until_next_event := false

var tasks = {}
var crew_members = {}
var rooms = {}
var schedule = {}

func _ready() -> void:
	$GameUI.set_ship(ship)
	$TaskFactory.game = self
	tasks = task_factory.get_common_chores()
	$GameUI.set_tasks(tasks)
	crew_members = ship.get_crew_members()
	for crew_name in crew_members:
		schedule[crew_name] = []

	rooms = ship.get_rooms()

	update_task_and_crew_count()
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
	update_task_and_crew_count()

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
	ship.update_state()
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
#		crew_members[crew_name].task_count = schedule[crew_name].size()
		crew_members[crew_name].scheduled_tasks = schedule[crew_name]
		for task_id in schedule[crew_name]:
			if counter.has(task_id) and counter[task_id].find(crew_name) == -1:
				counter[task_id].push_back(crew_name)
			else:
				counter[task_id] = [crew_name]

	for task_id in tasks:
		if counter.has(task_id):
			tasks[task_id].crew_count = counter[task_id].size()
			tasks[task_id].assigned_crew = counter[task_id]
		else:
			tasks[task_id].crew_count = 0
			tasks[task_id].assigned_crew = []


func apply_task_effect(task: Task) -> void:
	var effects = task.get_effect()
	for effect_key in effects:
		var data = effects[effect_key]
		match effect_key:
			"ship-speed": ship.change_speed(data)
			"ship-max-speed": ship.change_max_speed(data)
			"ship-water": ship.change_water(data)
			"ship-food": ship.change_food(data)
			"ship-air-filter": ship.clean_air_filter(data)
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
