extends Control

signal selection_changed

onready var color_rect := $ColorRect as ColorRect
onready var room_label := $Margin/Label as Label

var selected := false
var room_id

func set_room(room) -> void:
	room_id = room.room_id
	room_label.text = tr(room.room_name)

func set_selected(is_selected: bool) -> void:
	selected = is_selected
	update_color()

func update_color() -> void:
	color_rect.color.g = 0.5 if selected else 0.0

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		selected = not selected
		update_color()
		emit_signal("selection_changed", selected)
