class_name UIHumanLineStats
extends UICrewLineStats

func refresh() -> void:
#	$Efficiency/ProgressBar.value = crew.productivity()
#	$Sleep/ProgressBar.value = crew.wake_up_since
	pass

func prepare(the_crew) -> void:
	crew = the_crew
	$Name.text = crew.crew_name
