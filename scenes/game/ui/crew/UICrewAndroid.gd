tool
class_name UICrewAndroid
extends UICrewMember

onready var health := $Container/Stats/VBoxContainer/Health as CrewStat
onready var maintenance := $Container/Stats/VBoxContainer/Maintenance as CrewStat
onready var efficiency := $Container/Stats/VBoxContainer/Efficiency as CrewStat

func refresh() -> void:
	if crew is CrewMember:
		health.update_progress(crew.get_health())
		maintenance.update_progress(crew.hours_before_next_maintenance)
		efficiency.update_progress(crew.efficiency)
