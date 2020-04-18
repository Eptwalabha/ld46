class_name GameUI
extends Control

signal next_hour_clicked
signal next_event_clicked

onready var label_date := $Actions/HBoxContainer/Date as Label

func _ready() -> void:
	pass # Replace with function body.

func update_ui(hour: int) -> void:
	label_date.text = "hour: %s" % hour

func _on_NextHour_pressed() -> void:
	emit_signal("next_hour_clicked")

func _on_NextEvent_pressed() -> void:
	emit_signal("next_event_clicked")

func _on_Task_toggled(button_pressed: bool) -> void:
	if button_pressed:
		$TaskList.open()
	else:
		$TaskList.close()


func _on_TaskList_on_window_closed(window) -> void:
	match window.title:
		"ui_task_list": 
			$Actions/HBoxContainer/Task.pressed = false
		_ :
			pass
