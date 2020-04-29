class_name Ship
extends Node2D

signal room_selected(room_id)

var rooms := {}
var max_speed_ua : float = 2.0
var speed_ua : float = 2.0
var distance_covered : float = 0.0
var food : int = 10
var water : int = 10
var air_filter : float = 1.0

func _ready() -> void:
	rooms = get_rooms()
	for room_id in rooms:
		rooms[room_id].connect("room_selected", self, "_on_room_selected", [room_id])
	set_process_unhandled_input(true)

func get_crew_members() -> Dictionary:
	var crew_members = {}
	for crew in get_tree().get_nodes_in_group("ship-crew-member"):
		if crew is CrewMember and crew.visible:
			crew_members[crew.crew_name] = crew
	return crew_members

func get_rooms() -> Dictionary:
	var the_rooms = {}
	for room in get_tree().get_nodes_in_group("ship-room"):
		if room is ShipRoom:
			the_rooms[room.room_id] = room
	return the_rooms

func update_state() -> void:
	distance_covered += speed_ua / 24.0
	air_filter -= .03
	for room_id in rooms:
		rooms[room_id].update_state()

func change_food(amount: int) -> void:
	food = int(clamp(food + amount, 0, 999))

func clean_air_filter(amount: int) -> void:
	air_filter = clamp(air_filter + amount, 0, 1.0)

func change_water(amount: int) -> void:
	water = int(clamp(water + amount, 0, 999))

func change_speed(amount: float) -> void:
	speed_ua = clamp(speed_ua + amount, 0.5, max_speed_ua)

func change_max_speed(amount: float) -> void:
	max_speed_ua += amount
	max_speed_ua = clamp(max_speed_ua + amount, .5, 2)
	speed_ua = clamp(speed_ua, 0, max_speed_ua)

func hours_until_goal(goal) -> float:
	var rest_distance = (goal - distance_covered) / (speed_ua / 240)
	return ceil(rest_distance) / 10

func air_filter_efficiency() -> float:
	return 0.8 + 0.6 * air_filter

func is_room_available(room_id: String) -> bool:
	return rooms.has(room_id) and rooms[room_id].is_available()

func move_crew_member(crew: CrewMember, next_room_id: String, default_room_id: String = "living") -> void:
	var current_room_id = crew.room_id
	if current_room_id == next_room_id:
		return
	if not is_room_available(next_room_id):
		next_room_id = default_room_id
	var next_room = rooms[next_room_id]
	if rooms.has(current_room_id):
		var current_room : ShipRoom = rooms[current_room_id]
		current_room.crew_leaves(crew.crew_name)
	crew.position = next_room.crew_moves_in(crew.crew_name)
	crew.room_id = next_room.room_id

func move_crew_anywhere(crew: CrewMember) -> void:
	var free_rooms = []
	for room_id in rooms:
		var room : ShipRoom = rooms[room_id]
		if is_room_available(room_id):
			if room is ShipRoomPrivateQuarter and room.room_id != crew.crew_name:
				continue
			free_rooms.push_back(room.room_id)
	if free_rooms.size() > 0:
		var next_room : String = free_rooms[randi() % free_rooms.size()]
		move_crew_member(crew, next_room)

func is_crew_in_room(crew_name: String, room_id: String) -> bool:
	return rooms[room_id].is_crew_an_occupant(crew_name)

func get_sick_crew_in_room(_room_id: int) -> Array:
	return []

func set_room_selection(selection_enabled: bool) -> void:
	for room_id in rooms:
		rooms[room_id].set_selectable(selection_enabled)

func _on_room_selected(room_id) -> void:
	emit_signal("room_selected", room_id)
