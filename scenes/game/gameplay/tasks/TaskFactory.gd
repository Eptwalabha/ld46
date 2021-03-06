class_name TaskFactory
extends Node

var random_tasks = {}
var used = []
var available = []
var game

var TaskResource = preload("res://scenes/game/gameplay/tasks/Task.tscn")

func _ready() -> void:
	var file = File.new()
	file.open("res://assets/task/tasks.json", file.READ)
	var json = file.get_as_text()
	file.close()
	random_tasks = JSON.parse(json).result
	reset()

func reset() -> void:
	used = []
	available = random_tasks.keys()

func spawn_random_task(hour: int) -> Task:
	var key = available[randi() % available.size()]
	used.push(key)
	var data = random_tasks[key]
	var task = build_task(key, data)
	task.start_at = hour
	return task

func get_common_chores() -> Dictionary:
	var chores = [
		get_water_task(),
		get_food_task(),
#		get_air_filter_task(),
		get_viral_test_task(),
		get_build_mask_task(),
	]
	var r = {}
	for chore in chores:
		r[chore.task_id] = chore
	return r

func build_task(key: String, data: Dictionary) -> Task:
	var task = TaskResource.instance()
	data.title = tr("task_title_%s" % key)
	data.description = tr("task_description_%s" % key)
	task.build_from_data(data)
	return task
	
func _val(key: String, data: Dictionary, default):
	if data.has(key):
		return data[key]
	return default

func get_water_task() -> Task:
	var task = TaskResource.instance()
	var data = {
		'title': tr("task_title_clean_water"),
		'description': tr("task_description_clean_water"),
		'time_to_complete': 2.0,
		'expires': false,
		'repeat_once_complete': true,
		'success': {
			"ship-water": 5,
		},
		'max_crew': 2,
		'cooldown': 0.0,
		'room_id': "kitchen",
	}
	task.build_from_data(data)
	return task

func get_food_task() -> Task:
	var task = TaskResource.instance()
	var data = {
		'title': tr("task_title_prepare_food"),
		'description': tr("task_description_prepare_food"),
		'time_to_complete': 2.0,
		'expires': false,
		'repeat_once_complete': true,
		'success': {
			"ship-food": 3,
		},
		'max_crew': 2,
		'cooldown': 0.0,
		'room_id': "kitchen",
	}
	task.build_from_data(data)
	return task

func get_air_filter_task() -> Task:
	var task = TaskResource.instance()
	var data = {
		'title': tr("task_title_clean_air_filter"),
		'description': tr("task_description_clean_air_filter"),
		'time_to_complete': 2.0,
		'expires': false,
		'repeat_once_complete': true,
		'success': {
			"ship-filter": 5,
		},
		'max_crew': 2,
		'cooldown': 10.0,
		'rooms': ["technical", "living", "medical"],
	}
	task.build_from_data(data)
	return task

func get_viral_test_task() -> Task:
	var task = TaskResource.instance()
	var data = {
		'title': tr("task_title_build_viral_test"),
		'description': tr("task_description_build_viral_test"),
		'time_to_complete': 6.0,
		'expires': false,
		'repeat_once_complete': true,
		'success': {
			"viral-test": 2,
		},
		'max_crew': 2,
		'cooldown': 10.0,
		'room_id': "medical",
	}
	task.build_from_data(data)
	return task

func get_build_mask_task() -> Task:
	var task = TaskResource.instance()
	var data = {
		'title': tr("task_title_build_mask"),
		'description': tr("task_description_build_mask"),
		'time_to_complete': 6.0,
		'expires': false,
		'repeat_once_complete': true,
		'success': {
			"viral-mask": 4,
		},
		'max_crew': 2,
		'cooldown': 10.0,
		'room_id': "medical",
	}
	task.build_from_data(data)
	return task
