class_name UIRoomSelection
extends Control

signal room_selected(crew_name, room_id)

onready var room_list := $Control/Window/Margin/Container/Rooms/Center/Lines as VBoxContainer

var room_selected
var crew_name

func prepare(rooms: Dictionary) -> void:
	var RoomLine = load("res://scenes/game/ui/room/UIRoomLine.tscn")
	for room_id in rooms:
		var room = rooms[room_id]
		var line = RoomLine.instance()
		room_list.add_child(line)
		line.set_room(room)
		line.connect("selection_changed", self, "_on_room_selection_changed", [room_id])

func open(the_crew_name) -> void:
	crew_name = the_crew_name
	for line in room_list.get_children():
		line.set_selected(false)
	$Control/Window.show()
	show()

func _on_Confirm_pressed() -> void:
	emit_signal("room_selected", crew_name, room_selected)
	hide()

func _on_Cancel_pressed() -> void:
	hide()

func _on_Window_on_window_closed(_window) -> void:
	hide()

func _on_ColorRect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		hide()

func _on_room_selection_changed(is_selected: bool, the_room_selected: String) -> void:
	$Control/Window/Margin/Container/Actions/Confirm/Confirm.disabled = not is_selected
	room_selected = the_room_selected
	for line in room_list.get_children():
		line.set_selected(is_selected and line.room_id == room_selected)
