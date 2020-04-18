class_name GameUI
extends Control

signal next_hour_clicked
signal next_event_toggled(button_pressed)

onready var label_date := $Actions/HBoxContainer/Date as Label
onready var crew_list := $CrewList as UICrewList

func _ready() -> void:
	pass # Replace with function body.

func setup(ship: Ship) -> void:
	crew_list.set_crew_members(ship.get_crew_members())

func update_ui(hour: int) -> void:
	label_date.text = "hour: %s" % hour

func next_event_over() -> void:
	$Actions/HBoxContainer/NextEvent.pressed = false

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
		"ui_task_list": 
			$Actions/HBoxContainer/Task.pressed = false
		"ui_crew_list" :
			$Actions/HBoxContainer/Crew.pressed = false
		_ :
			pass
