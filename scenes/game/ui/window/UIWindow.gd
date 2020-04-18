tool
class_name UIWindow
extends Control


export(String) var title := "title" setget _set_window_title
export(bool) var closable := true setget _set_window_closable


func _ready() -> void:
	print("title %s" % title)

func _set_window_title(new_title) -> void:
	title = new_title
	$MarginContainer/Content/Header/Content/Title.text = title

func _set_window_closable(is_closable) -> void:
	closable = is_closable
	$MarginContainer/Content/Header/Content/Close.visible = closable

func _on_Close_pressed() -> void:
	hide()
