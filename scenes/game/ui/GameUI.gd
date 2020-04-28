class_name GameUI
extends Control

signal next_hour_clicked
signal next_event_toggled(button_pressed)

onready var label_date := $Container/Actions/Container/Stats/Time/Date as Label
onready var distance_progress := $Container/Actions/Container/Stats/Distance/Progress as ProgressBar
onready var crew_list := $Container/Columns/CrewList as UICrewList
onready var next_event := $Container/Actions/Container/NextEvent as Button
onready var next_hour := $Container/Actions/Container/NextHour as Button
onready var crew_button := $Container/Actions/Container/Crew as Button
onready var crew_selection := $CrewSelection as UICrewSelection
onready var room_selection := $RoomSelection as UIRoomSelection

var ship = null
var game = null

func _ready() -> void:
	game = get_parent().get_parent()

func set_ship(the_ship: Ship) -> void:
	ship = the_ship
	var crew_members = ship.get_crew_members()
	crew_list.set_crew_members(crew_members)
	crew_selection.prepare(crew_members)
	room_selection.prepare(ship.get_rooms())

func refresh(hour: int) -> void:
	var time_before_end = ship.hours_until_goal(game.ua_goal)
	var p1 = "" if hour <= 1 else "s"
	var p2 = "" if time_before_end <= 1 else "s"
	label_date.text = "%s hour%s (%s hour%s to go)" % [hour, p1, time_before_end, p2]
	distance_progress.max_value = game.ua_goal
	distance_progress.value = ship.distance_covered
	crew_list.refresh()

func next_event_over() -> void:
	next_event.pressed = false

func _on_NextHour_pressed() -> void:
	emit_signal("next_hour_clicked")

func _on_NextEvent_toggled(button_pressed: bool) -> void:
	emit_signal("next_event_toggled", button_pressed)

func _on_Crew_toggled(button_pressed: bool) -> void:
	crew_list.close(not button_pressed)

func _on_UI_window_closed(window) -> void:
	match window.title:
		"ui_crew_list" : crew_button.pressed = false
		_ : pass

func _on_UI_window_opened(window) -> void:
	pass

func _on_RoomSelection_room_selected(crew: CrewMember, room_id: String) -> void:
	ship.move_crew_member(crew, room_id)

func _on_CrewList_on_crew_selected(crew_id) -> void:
	room_selection.open(crew_id)
