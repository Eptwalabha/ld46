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
	$TaskList.visible = button_pressed
