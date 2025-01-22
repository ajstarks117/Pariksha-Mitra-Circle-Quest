extends Node2D

var dragging = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed and is_mouse_over()

	if event is InputEventMouseMotion and dragging:
		global_position += event.relative

func is_mouse_over() -> bool:
	return (global_position - get_global_mouse_position()).length() < 10
