tool
class_name UICrewHuman
extends UICrewMember

onready var hunger_progress := $Container/Stats/VBoxContainer/Hunger as CrewStat
onready var thirst_progress := $Container/Stats/VBoxContainer/Thirst as CrewStat
onready var health_progress := $Container/Stats/VBoxContainer/Health as CrewStat
onready var exhaustion_progress := $Container/Stats/VBoxContainer/Exhaustion as CrewStat

func refresh() -> void:
	if crew is CrewMember:
		health_progress.update_progress(crew.get_health())
		hunger_progress.update_progress(crew.hunger)
		thirst_progress.update_progress(crew.thirst)
		exhaustion_progress.update_progress(crew.exhaustion)
