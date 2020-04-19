tool
class_name CrewStat
extends HBoxContainer

export(String) var stat_name := "ui_stat_name"
export(float) var max_value := 100.0
onready var progress := $Progress as ProgressBar
onready var label := $Label as Label

func _ready() -> void:
	label.text = tr(stat_name)
	progress.max_value = max_value

func update_progress(value: int) -> void:
	progress.value = value
