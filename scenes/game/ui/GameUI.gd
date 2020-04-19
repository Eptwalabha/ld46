class_name GameUI
extends Control

signal next_hour_clicked
signal next_event_toggled(button_pressed)

onready var label_date := $Actions/Container/Stats/Time/Date as Label
onready var distance_progress := $Actions/Container/Stats/Distance/Progress as ProgressBar
onready var crew_list := $CrewList as UICrewList
onready var tasks_list := $TaskList as UITaskList
onready var task_detail := $TaskDetail as UITaskDetail
onready var crew_assignment := $AssignCrew as UIAssignCrew
onready var next_event := $Actions/Container/NextEvent as Button
onready var next_hour := $Actions/Container/NextHour as Button
onready var crew_button := $Actions/Container/Crew as Button
onready var task_button := $Actions/Container/Task as Button

var ship = null
var game = null

func _ready() -> void:
	game = get_parent()

func set_ship(the_ship: Ship) -> void:
	ship = the_ship
	crew_list.set_crew_members(ship.get_crew_members())

func set_tasks(tasks: Array) -> void:
	tasks_list.set_tasks_list(tasks)

func refresh(hour: int) -> void:
	label_date.text = "%s hour%s" % [hour, "" if hour <= 1 else "s"]
	distance_progress.max_value = 30
	distance_progress.value = ship.distance_covered
#	crew_list.refresh(data.crew_members)
	tasks_list.refresh()

func next_event_over() -> void:
	next_event.pressed = false

func _on_NextHour_pressed() -> void:
	emit_signal("next_hour_clicked")

func _on_NextEvent_toggled(button_pressed: bool) -> void:
	emit_signal("next_event_toggled", button_pressed)

func _on_Task_toggled(button_pressed: bool) -> void:
	$TaskList.close(not button_pressed)

func _on_Crew_toggled(button_pressed: bool) -> void:
	$CrewList.close(not button_pressed)

func _on_UI_window_closed(window) -> void:
	match window.title:
		"ui_task_list": task_button.pressed = false
		"ui_crew_list" : crew_button.pressed = false
		"ui_task_title_window": tasks_list.deselect_all()
		_ : pass

func _on_TaskList_task_infos_requested(task_id) -> void:
	var assigned_crew = []
	for crew in game.get_assigned_crew(task_id):
		assigned_crew.push_back(crew.crew_name)
	var task = game.get_task(task_id)
	tasks_list.select_task(task_id)
	task_detail.open(task, assigned_crew)

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
	task_detail.open(task, crew_members)
	tasks_list.refresh()
