class_name ContextWheel2D
extends Node2D

signal wheel_opened(crew_name)
signal wheel_closed(crew_name)
signal give_water_clicked(crew_name)
signal give_food_clicked(crew_name)
signal heal_crew_clicked(crew_name)
signal pause_crew_clicked(crew_name)
signal move_crew_clicked(crew_name)

onready var anim = $AnimationPlayer as AnimationPlayer

var current_crew_name
var opened := true

func _ready() -> void:
	hide() 

func open(crew) -> void:
	if crew.crew_name == current_crew_name and opened:
		close()
		return
	current_crew_name = crew.crew_name
	transform = crew.get_global_transform()
	opened = true
	if not visible:
		visible = true
	emit_signal("wheel_opened", current_crew_name)
	anim.play("open")

func close() -> void:
	if opened:
		opened = false
		emit_signal("wheel_closed", current_crew_name)
		anim.play("close")

func is_open() -> bool:
	return opened

func on_wheel_button_clicked(button_id) -> void:
	if not opened:
		return
	match button_id:
		"pause": emit_signal("pause_crew_clicked", current_crew_name)
		"move": emit_signal("move_crew_clicked", current_crew_name)
		"heal": emit_signal("heal_crew_clicked", current_crew_name)
		"food": emit_signal("give_food_clicked", current_crew_name)
		"water": emit_signal("give_water_clicked", current_crew_name)
		_: pass
