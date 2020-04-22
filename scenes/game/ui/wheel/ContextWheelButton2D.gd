class_name ContextWheelButton2D
extends Node2D

signal on_context_wheel_button_clicked(button_id)

export(String) var button_id := ""

func set_text(text: String) -> void:
	$TextureButton/Info.visible = text != ""
	$TextureButton/Info.text = tr(text)

func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		emit_signal("on_context_wheel_button_clicked", button_id)


func _on_TextureButton_pressed() -> void:
	emit_signal("on_context_wheel_button_clicked", button_id)
