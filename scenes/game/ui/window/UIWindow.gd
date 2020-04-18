tool
class_name UIWindow
extends Control

signal on_window_closed(window_name)
signal on_window_opened

export(String) var title := "title" setget _set_window_title
export(bool) var closable := true setget _set_window_closable

func close(close: bool) -> void:
	if close:
		emit_signal("on_window_closed", self)
		hide()
	else:
		emit_signal("on_window_opened")
		show()

func _set_window_title(new_title) -> void:
	title = new_title
	$MarginContainer/Content/Header/Content/Title.text = tr(title)

func _set_window_closable(is_closable) -> void:
	closable = is_closable
	$MarginContainer/Content/Header/Content/Close.visible = closable

func _on_Close_pressed() -> void:
	close(true)
