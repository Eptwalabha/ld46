class_name GameUI
extends Control

signal next_hour_clicked
signal next_event_toggled(button_pressed)

onready var label_date := $Actions/Container/Stats/Time/Date as Label
onready var distance_progress := $Actions/Container/Stats/Distance/Progress as ProgressBar
onready var crew_list := $CrewList as UICrewList
onready var next_event := $Actions/Container/NextEvent as Button
onready var next_hour := $Actions/Container/NextHour as Button
onready var crew_button := $Actions/Container/Crew as Button
onready var task_button := $Actions/Container/Task as Button

var ship = null

func _ready() -> void:
	pass # Replace with function body.

func setup(the_ship: Ship) -> void:
	ship = the_ship
	crew_list.set_crew_members(ship.get_crew_members())

func update_ui(hour: int) -> void:
	label_date.text = "hour: %s" % hour
	distance_progress.max_value = 30
	distance_progress.value = ship.distance_covered

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
		_ : pass
