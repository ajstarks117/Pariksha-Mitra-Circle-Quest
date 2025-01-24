extends Control

var radius = 100  # Adjust based on your desired circle size
var circle_points = []
var start_angle = 0.0
var end_angle = 0.0
var is_drawing = false

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = get_global_mouse_position()
		if (mouse_pos - position).length() <= radius:
			start_angle = (mouse_pos - position).angle()
			is_drawing = true

	if event is InputEventMouseMotion and is_drawing:
		var mouse_pos = get_global_mouse_position()
		end_angle = (mouse_pos - position).angle()
		queue_redraw()  # Request to redraw the scene

	if event is InputEventMouseButton and not event.pressed:
		is_drawing = false
		var angle_diff = abs(end_angle - start_angle)
		if angle_diff > PI:
			print("Major Arc")
		else:
			print("Minor Arc")
		queue_redraw()  # Request to redraw the scene


func _draw():
	# Draw the circle
	for i in range(circle_points.size() - 1):
		draw_line(circle_points[i] + position, circle_points[i + 1] + position, Color(1, 1, 1), 2)

	# Draw the arc if currently drawing
	if is_drawing:
		var start_point = Vector2(cos(start_angle), sin(start_angle)) * radius + position
		var end_point = Vector2(cos(end_angle), sin(end_angle)) * radius + position
		draw_line(start_point, end_point, Color(1, 0, 0), 4)  # Draw the arc in red
