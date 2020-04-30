class_name Game
extends Node

var TaskResource = load("res://scenes/game/gameplay/tasks/Task.tscn")
var TASK_STATE = preload("res://script/game_enum.gd").TASK_STATE

onready var ui := $UI/GameUI as GameUI
onready var ship := $Ship as Ship
onready var task_factory := $TaskFactory
onready var wheel := $ContextWheel as ContextWheel2D

export(int) var hours_before_next_heal = 24
var heal_count := 0.0
var ttl_heal := 0
var hour : int = 0
var ua : float = 0.0
export(float) var ua_goal := 30 # neptune
var until_next_event := false

export(int) var mask_batch_period = 12
var next_mask_batch := 12

var tasks = {}
var crew_members = {}
var schedule = {}
var rooms = {}
var living_room : ShipRoom
var game_over : bool = false
var nbr_masks = 2
var nbr_tests = 2

func _ready() -> void:
	randomize()
	next_mask_batch = mask_batch_period
	ui.set_ship(ship)
	$TaskFactory.game = self
	tasks = task_factory.get_common_chores()
	
	rooms = ship.get_rooms()
	living_room = rooms['living']
	crew_members = ship.get_crew_members()
	var nbr_contaminated = 0
	for crew_name in crew_members:
		crew_members[crew_name].connect("crew_clicked", self, "_on_crew_clicked")
		schedule[crew_name] = []
		ship.move_crew_anywhere(crew_members[crew_name])
		if randf() > .5 and nbr_contaminated < 4:
			nbr_contaminated += 1
			crew_members[crew_name].contaminated()
			crew_members[crew_name].update_visual_state()
			

	var room_keys = rooms.keys()
	nbr_contaminated = 0
	while nbr_contaminated < 4:
		var i = randi() % room_keys.size()
		var room_id = room_keys[i]
		if rooms[room_id].contaminable:
			nbr_contaminated += 1
			rooms[room_id].contaminate()
			rooms[room_id].current_room_state.update_visual()
			room_keys.remove(i)

	update_task_and_crew_count()
	ui.refresh(0)
	game_over = false

func _process(delta: float) -> void:
	$Background/ParallaxBackground.scroll_base_offset.x -= delta * 1000

func get_assigned_crew(task_id: int) -> Array:
	var assigned_crew_members = []
	for crew_name in crew_members:
		if schedule[crew_name].has(task_id):
			assigned_crew_members.push_back(crew_members[crew_name])
	return assigned_crew_members

func get_task(task_id: int) -> Task:
	return tasks[task_id]

func get_crew_members() -> Array:
	return crew_members

func assign_crew_to_task(task_id, crew_to_assign) -> void:
	if not tasks.has(task_id):
		return

	for crew_name in schedule:
		var crew_tasks = schedule[crew_name]
		var is_one_assigned = crew_to_assign.has(crew_name)
		var has_already_this_task = crew_tasks.has(task_id)
		if is_one_assigned and not has_already_this_task:
			schedule[crew_name].push_back(task_id)
		elif not is_one_assigned and has_already_this_task:
			schedule[crew_name].remove(crew_tasks.find(task_id))

	tasks[task_id].crew_count = crew_to_assign.size()
	update_task_and_crew_count()

func next_event() -> void:
	if game_over:
		return
	until_next_event = true
	var fail_safe = hour + 100
	var amount = 0
	while not game_over and until_next_event and amount < 10:
		next_hour()
		if check_game_over():
			break
		yield(get_tree().create_timer(.1), "timeout")
		amount += 1
		if hour >= fail_safe:
			break
	until_next_event = false
	ui.next_event_over()

func next_hour() -> void:
	wheel.close()
	hour += 1
	update_crew()
	update_tasks()
	update_contagion()
	ship.update_state()
	if ttl_heal > 0:
		ttl_heal -= 1
	next_mask_batch -= 1
	if next_mask_batch == 0:
		nbr_masks += 2
		next_mask_batch = mask_batch_period
	refresh_menu()
	ui.refresh(hour)
	spawn_random_events()
#	process_events()

func heal_crew(crew_name) -> void:
	if ttl_heal == 0:
		ttl_heal = hours_before_next_heal + int(heal_count * 24)
		heal_count += .5
		crew_members[crew_name].healed()
		refresh_menu()
	
func check_game_over() -> bool:
	if is_ship_clean() and all_crew_healthy() or ship.distance_covered >= ua_goal:
		until_next_event = false
		game_over = true
		var _err = get_tree().change_scene("res://scenes/cutscenes/Victory.tscn")
		return true
	elif all_crew_are_dead():
		until_next_event = false
		var _err = get_tree().change_scene("res://scenes/cutscenes/GameOver.tscn")
		game_over = true
		return true
	return false

func all_crew_are_dead() -> bool:
	for crew_name in crew_members:
		if crew_members[crew_name].is_alive():
			return false
	return true

func is_ship_clean() -> bool:
	var contaminated_rooms = 0
	for room_id in rooms:
		if rooms[room_id].is_contaminated():
			contaminated_rooms += 1
	return contaminated_rooms == 0

func all_crew_healthy() -> bool:
	for crew_name in crew_members:
		if crew_members[crew_name].is_infected():
			return false
	return true

func update_tasks() -> void:
	for task_id in tasks:
		tasks[task_id].update_task(hour)

	# for each scheduled tasks
	for crew_name in schedule:
		if schedule[crew_name].size() == 0:
			continue
		var crew = crew_members[crew_name]
		for i in range(schedule[crew_name].size()):
			var task_id = schedule[crew_name][i]
			var task = tasks[task_id]
			if can_crew_work_on_task(crew, task):
				crew.work_on(task)
				break

	for task_id in tasks:
		var task = tasks[task_id]
		if task.is_active():
			continue
		match task.state:
			TASK_STATE.COMPLETE:
				apply_task_effect(task)
			TASK_STATE.EXPIRED:
				apply_task_effect(task)
			_: pass
		
		if task.state == TASK_STATE.DONE:
			for crew_name in schedule:
				if schedule[crew_name].size() == 0:
					continue
	update_task_and_crew_count()

func can_crew_work_on_task(crew: CrewMember, task: Task) -> bool:
	return task.state == TASK_STATE.ONGOING and crew.room_id == task.room_id

func update_task_and_crew_count() -> void:
	var counter = {}
	for crew_name in schedule:
		crew_members[crew_name].scheduled_tasks = schedule[crew_name]
		for task_id in schedule[crew_name]:
			if counter.has(task_id) and counter[task_id].find(crew_name) == -1:
				counter[task_id].push_back(crew_name)
			else:
				counter[task_id] = [crew_name]

	for task_id in tasks:
		if counter.has(task_id):
			tasks[task_id].crew_count = counter[task_id].size()
			tasks[task_id].assigned_crew = counter[task_id]
		else:
			tasks[task_id].crew_count = 0
			tasks[task_id].assigned_crew = []

func update_contagion() -> void:
	for room_id in rooms:
		var room : ShipRoom = rooms[room_id]
		var crew_ids = room.get_current_occupants()
		var healthy_crews = []
		var sick_crews = []
		for crew_id in crew_ids:
			var crew : CrewMember = crew_members[crew_id]
			# room to crew contagion
			room.visited_by(crew)
			if crew.is_infected():
				sick_crews.push_back(crew)
			else:
				healthy_crews.push_back(crew)
		# crew to crew contagion
		for crew in healthy_crews:
			for crew2 in sick_crews:
				crew.in_contact_with(crew2)

func apply_task_effect(task: Task) -> void:
	var effects = task.get_effect()
	for effect_key in effects:
		var data = effects[effect_key]
		match effect_key:
			"ship-speed": ship.change_speed(data)
			"ship-max-speed": ship.change_max_speed(data)
			"ship-water": ship.change_water(data)
			"ship-food": ship.change_food(data)
			"ship-air-filter": ship.clean_air_filter(data)
			"viral-test": nbr_tests += data
			"viral-mask": nbr_masks += data
			"room-contamination-level":
				var nbr = data
				if nbr > 0:
					pass
				else:
					pass
			_: pass

	task.end_task(hour)
	var m = schedule.keys()
	if task.state != TASK_STATE.DONE:
		m = task.crew_who_worked_on_it
	for crew_name in m:
		var i = schedule[crew_name].find(task.task_id)
		if i != -1:
			schedule[crew_name].remove(i)

func update_crew() -> void:
	for crew_id in crew_members:
		var crew = crew_members[crew_id]
		crew.update_state(hour)
		update_crew_position(crew)

func update_crew_position(crew: CrewMember) -> void:
	var crew_next_location = crew.get_location_request()
	match crew_next_location:
		"": pass
		"work": move_crew_for_work(crew)
		"random": ship.move_crew_anywhere(crew)
		"my-quarter": ship.move_crew_member(crew, crew.crew_name)
		# warning-ignore:unassigned_variable
		var room_id:
			ship.move_crew_member(crew, room_id)

func move_crew_for_work(crew: CrewMember) -> void:
	for task_id in crew.scheduled_tasks:
		var room_id = tasks[task_id].room_id
		if ship.is_crew_in_room(crew.crew_name, room_id):
			return
		if ship.is_room_available(room_id):
			ship.move_crew_member(crew, room_id)
			return
	ship.move_crew_anywhere(crew)

func give_mask_to(crew_name) -> void:
	if nbr_masks > 0 and crew_members[crew_name] is HumanCrew:
		crew_members[crew_name].give_mask()
		nbr_masks -= 1
		refresh_menu()

func check_ship_state() -> void:
	pass

func spawn_random_events() -> void:
	pass

func _on_Task_completed(_task: Task) -> void:
	pass

func _on_Task_failed(_task: Task) -> void:
	pass

func _on_GameUI_next_event_toggled(button_pressed) -> void:
	if until_next_event and not button_pressed:
		until_next_event = false
	elif button_pressed:
		next_event()

func _on_GameUI_next_hour_clicked() -> void:
	if game_over:
		return
	next_hour()
	var _a = check_game_over()

func _on_crew_clicked(crew: CrewMember) -> void:
#	wheel.toggle(crew)
	var menus = crew.get_contextual_menus()
	wheel.open(crew, menus)

func refresh_menu() -> void:
	wheel.refresh()

func _on_ContextWheel_wheel_closed(_crew_name) -> void:
	pass

func _on_ContextWheel_wheel_opened(_crew_name) -> void:
	pass

func _on_ContextWheel_give_mask_clicked(crew_name) -> void:
	give_mask_to(crew_name)

func _on_ContextWheel_heal_crew_clicked(crew_name) -> void:
	heal_crew(crew_name)
	wheel.close()

func _on_ContextWheel_move_crew_clicked(crew_name) -> void:
	wheel.close()
	ship.set_room_selection(true)
	ship.connect("room_selected", self, "_on_ship_room_selected", [crew_name], CONNECT_ONESHOT)

func _on_ship_room_selected(room_id, crew_name) -> void:
	ship.set_room_selection(false)
	crew_members[crew_name].next_location = room_id
	ship.move_crew_member(crew_members[crew_name], room_id)

func _on_ContextWheel_test_crew_clicked(crew_name) -> void:
	if nbr_tests > 0:
		nbr_tests -= 1
		var crew = crew_members[crew_name]
		crew.make_a_viral_test()
		wheel.close()
		var menus = crew.get_contextual_menus()
		wheel.open(crew, menus)
	refresh_menu()


func _on_Button_pressed() -> void:
	if TranslationServer.get_locale() == "fr_FR":
		TranslationServer.set_locale("en")
	else:
		TranslationServer.set_locale("fr_FR")
	$UI/Button.text = TranslationServer.get_locale()
	ui.refresh(hour)
