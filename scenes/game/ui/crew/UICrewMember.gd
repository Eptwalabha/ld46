class_name UICrewMember
extends MarginContainer

onready var name_label := $Container/Stats/Name/Label as Label
onready var hunger_progress := $Container/Stats/Hunger/Progress as ProgressBar
onready var thirst_progress := $Container/Stats/Thirst/Progress as ProgressBar
onready var health_progress := $Container/Stats/Health/Progress as ProgressBar
onready var exhaustion_progress := $Container/Stats/Exhaustion/Progress as ProgressBar

var crew : CrewMember = null

func _ready() -> void:
	_update_with_crew_info()

func set_crew_member(my_crew: CrewMember) -> void:
	crew = my_crew
	# warning-ignore:return_value_discarded
	crew.connect("crew_state_update", self, "_update_state")

func _update_with_crew_info() -> void:
	name_label.text = crew.crew_name
	hunger_progress.max_value = 72
	hunger_progress.value = crew.hunger
	thirst_progress.max_value = 24
	thirst_progress.value = crew.thirst
	exhaustion_progress.max_value = 24
	exhaustion_progress.value = crew.exhaustion

func _update_state() -> void:
	_update_with_crew_info()
