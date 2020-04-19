class_name Ship
extends Node2D

onready var rooms := $Rooms as Node2D

var max_speed_ua : float = 2.0
var speed_ua : float = 2.0
var distance_covered : float = 0.0
var food : int = 10
var water : int = 10
var air_filter : int = 0

func _ready() -> void:
	pass

func get_crew_members() -> Array:
	var crew_members = []
	for crew in $Crew.get_children():
		if crew is CrewMember:
			if crew.is_alive():
				crew_members.push_back(crew)
	return crew_members

func update_state() -> void:
	distance_covered += speed_ua / 24.0
	air_filter += 1
	for room in rooms.get_children():
		room.update_state()

func change_food(amount: int) -> void:
	food = int(clamp(food + amount, 0, 999))

func clean_air_filter(amount: int) -> void:
	air_filter -= amount
	if air_filter < 0:
		air_filter = 0

func change_water(amount: int) -> void:
	water = int(clamp(water + amount, 0, 999))

func change_speed(amount: float) -> void:
	speed_ua = clamp(speed_ua + amount, 0.5, max_speed_ua)

func change_max_speed(amount: float) -> void:
	max_speed_ua += amount
	if max_speed_ua < .5:
		max_speed_ua = .5
#	max_speed_ua = clamp(max_speed_ua + amount, 0.5, 2)
	speed_ua = clamp(speed_ua, 0, max_speed_ua)

func hours_until_goal(goal) -> float:
	var rest_distance = (goal - distance_covered) / (speed_ua / 240)
	return ceil(rest_distance) / 10

func air_filter_efficiency() -> float:
	if air_filter < 10:
		return 1.0
	elif air_filter < 20:
		return .8
	elif air_filter < 30:
		return .5
	else:
		return .1
