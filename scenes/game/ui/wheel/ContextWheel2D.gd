class_name ContextWheel2D
extends Node2D

signal wheel_opened(crew_name)
signal wheel_closed(crew_name)
signal give_water_clicked(crew_name)
signal give_food_clicked(crew_name)
signal give_mask_clicked(crew_name)
signal heal_crew_clicked(crew_name)
signal pause_crew_clicked(crew_name)
signal move_crew_clicked(crew_name)
signal test_crew_clicked(crew_name)

onready var anim = $AnimationPlayer as AnimationPlayer
onready var buttons = $Buttons as Node2D
onready var heal = $Buttons/Heal as ContextWheelButton2D
onready var masks = $Buttons/Mask as ContextWheelButton2D
onready var test = $Buttons/Test as ContextWheelButton2D

export(float) var dist := 50.0

var current_crew_name
var opened := true

func _ready() -> void:
	hide()
	refresh()
	for button in buttons.get_children():
		if button is ContextWheelButton2D:
			if button.connect("on_context_wheel_button_clicked", self, "_on_wheel_button_clicked"):
				button.hide()

func open(crew, menus) -> void:
	if crew.crew_name == current_crew_name and opened:
		close()
		return
	for button in buttons.get_children():
		if button is ContextWheelButton2D:
			button.visible = menus.has(button.button_id)
	current_crew_name = crew.crew_name
	transform = crew.get_global_transform()
	_place_buttons()
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

func _place_buttons() -> void:
	var step := TAU / 8.0
	var angle := 0.0 - PI / 2.0
	for button in buttons.get_children():
		if button is ContextWheelButton2D and button.visible:
			button.transform.origin = Vector2(cos(angle) * dist, sin(angle) * dist)
			angle += step
			

func _on_wheel_button_clicked(button_id) -> void:
	if not opened:
		return
	match button_id:
		"pause": emit_signal("pause_crew_clicked", current_crew_name)
		"move": emit_signal("move_crew_clicked", current_crew_name)
		"heal": emit_signal("heal_crew_clicked", current_crew_name)
		"test": emit_signal("test_crew_clicked", current_crew_name)
		"food": emit_signal("give_food_clicked", current_crew_name)
		"water": emit_signal("give_water_clicked", current_crew_name)
		"mask": emit_signal("give_mask_clicked", current_crew_name)
		_: pass

func refresh() -> void:
	var game = get_parent()
	masks.set_text(str(game.nbr_masks))
	var heal_text = "" if game.ttl_heal == 0 else str(game.ttl_heal)
	heal.set_text(heal_text)
	test.set_text(str(game.nbr_tests))

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"close": hide()
		_: pass
