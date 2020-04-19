class_name GameUI
extends Control

signal next_hour_clicked
signal next_event_toggled(button_pressed)

onready var label_date := $Container/Actions/Container/Stats/Time/Date as Label
onready var distance_progress := $Container/Actions/Container/Stats/Distance/Progress as ProgressBar
onready var crew_list := $Container/Columns/CrewList as UICrewList
onready var tasks_list := $Container/Columns/TaskList as UITaskList
onready var task_detail := $Container/Columns/Middle/Task/TaskDetail as UITaskDetail
onready var crew_assignment := $Container/Columns/Middle/Task/AssignCrew as UIAssignCrew
onready var next_event := $Container/Actions/Container/NextEvent as Button
onready var next_hour := $Container/Actions/Container/NextHour as Button
onready var crew_button := $Container/Actions/Container/Crew as Button
onready var task_button := $Container/Actions/Container/Task as Button

var ship = null
var game = null

func _ready() -> void:
	game = get_parent()

func set_ship(the_ship: Ship) -> void:
	ship = the_ship
	crew_list.set_crew_members(ship.get_crew_members())

func set_tasks(tasks: Dictionary) -> void:
	tasks_list.set_tasks_list(tasks)

func refresh(hour: int) -> void:
	var time_before_end = ship.hours_until_goal(game.ua_goal)
	var p1 = "" if hour <= 1 else "s"
	var p2 = "" if time_before_end <= 1 else "s"
	label_date.text = "%s hour%s (%s hour%s to go)" % [hour, p1, time_before_end, p2]
	distance_progress.max_value = game.ua_goal
	distance_progress.value = ship.distance_covered
	crew_list.refresh()
	tasks_list.refresh()
	task_detail.refresh()

func next_event_over() -> void:
	next_event.pressed = false

func _on_NextHour_pressed() -> void:
	emit_signal("next_hour_clicked")
	crew_assignment.close(true)

func _on_NextEvent_toggled(button_pressed: bool) -> void:
	emit_signal("next_event_toggled", button_pressed)
	crew_assignment.close(true)

func _on_Task_toggled(button_pressed: bool) -> void:
	tasks_list.close(not button_pressed)

func _on_Crew_toggled(button_pressed: bool) -> void:
	crew_list.close(not button_pressed)

func _on_UI_window_closed(window) -> void:
	match window.title:
		"ui_task_list": task_button.pressed = false
		"ui_crew_list" : crew_button.pressed = false
		"ui_task_title_window": tasks_list.deselect_all()
		_ : pass

func _on_UI_window_opened(window) -> void:
	match window.title:
		"ui_task_title_window":
			tasks_list.select_task(window.task.task_id)
		_ : pass

func _on_TaskList_task_infos_requested(task_id) -> void:
	var task = game.get_task(task_id)
	tasks_list.select_task(task_id)
	task_detail.open(task)

func _on_TaskDetail_assignment_requested(task_id) -> void:
	var crew_members = game.get_crew_members()
	var assigned_crew = []
	for crew in game.get_assigned_crew(task_id):
		assigned_crew.push_back(crew.crew_name)
	var task = game.get_task(task_id)
	crew_assignment.open(task, crew_members, assigned_crew)
	task_detail.close(true)

func _on_AssignCrew_assign_crew_members(task_id, crew_members) -> void:
	game.assign_crew_to_task(task_id, crew_members)
	var task = game.get_task(task_id)
	task_detail.open(task)
	tasks_list.refresh()
