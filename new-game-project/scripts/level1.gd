extends Node2D

var traced_points = []
var total_points = 100
var diameter = 300  # Default diameter in pixels
var circle_center = Vector2(598, 256)
var progress = 0.0
var tolerance = 10  # Allowable error margin for tracing
var start_point = null
var is_tracing = false
var min_points = 50  # Minimum points needed before checking completion
var pixels_per_cm = 30  # Scale factor: 30 pixels = 1 cm
var start_angle = 0.0  # Store the starting angle
var dragging_line_edit = false
var line_edit_offset = Vector2.ZERO
var circumference_displayed = false

func _ready():
	draw_circle_outline()
	$LineEdit.mouse_entered.connect(_on_line_edit_mouse_entered)
	$LineEdit.mouse_exited.connect(_on_line_edit_mouse_exited)

func _on_line_edit_mouse_entered():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging_line_edit = true
		line_edit_offset = $LineEdit.position - get_viewport().get_mouse_position()

func _on_line_edit_mouse_exited():
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging_line_edit = false

func _input(event):
	if dragging_line_edit:
		if event is InputEventMouseMotion:
			$LineEdit.position = event.position + line_edit_offset
		elif event is InputEventMouseButton and not event.pressed:
			dragging_line_edit = false
		return  # Skip other input processing while dragging

	var mouse_pos = Vector2.ZERO
	if event is InputEventMouseButton:
		mouse_pos = event.position
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Check if near start marker and on circle
				var radius = diameter / 2
				var distance_from_center = (mouse_pos - circle_center).length()
				if distance_from_center < radius + tolerance and distance_from_center > radius - tolerance:
					# Reset if circumference was previously displayed
					if circumference_displayed:
						circumference_displayed = false
						progress = 0.0
						$Label.text = "Tracing started..."
					
					start_point = mouse_pos
					is_tracing = true
					traced_points.clear()
					traced_points.append(mouse_pos)
					# Calculate and store the starting angle
					start_angle = atan2(mouse_pos.y - circle_center.y, mouse_pos.x - circle_center.x)
					if start_angle < 0:
						start_angle += 2 * PI
					$Label.text = "Tracing started..."
			else:
				# Stop tracing on mouse button release
				is_tracing = false
				if len(traced_points) > min_points:
					check_completion(mouse_pos)
				else:
					$Label.text = "Tracing incomplete - try again"
					traced_points.clear()
					start_point = null
	
	elif event is InputEventMouseMotion and is_tracing:
		mouse_pos = event.position
		var radius = diameter / 2
		var distance_from_center = (mouse_pos - circle_center).length()
		
		# Check if mouse is on the circle
		if distance_from_center < radius + tolerance and distance_from_center > radius - tolerance:
			if mouse_pos not in traced_points:
				traced_points.append(mouse_pos)
				update_progress(mouse_pos)
		else:
			# If mouse moves off circle, stop tracing
			is_tracing = false
			$Label.text = "Tracing interrupted - try again"
			traced_points.clear()
			start_point = null

func check_completion(current_pos):
	var distance_to_start = (current_pos - start_point).length()
	if distance_to_start < tolerance:
		display_final_circumference()
		return
	else:
		$Label.text = "Tracing incomplete - try again"
		traced_points.clear()
		start_point = null

func draw_circle_outline():
	$Line2D.clear_points()
	var radius = diameter / 2
	for i in range(total_points + 1):  # +1 to close the circle
		var angle = i * (2 * PI / total_points)
		var point = circle_center + Vector2(radius * cos(angle), radius * sin(angle))
		$Line2D.add_point(point)

func update_progress(current_pos):
	# Calculate current angle
	var current_angle = atan2(current_pos.y - circle_center.y, current_pos.x - circle_center.x)
	if current_angle < 0:
		current_angle += 2 * PI
	
	# Calculate angle difference from start
	var angle_diff = current_angle - start_angle
	if angle_diff < 0:
		angle_diff += 2 * PI
	
	# Update progress based on angle traced
	progress = angle_diff / (2 * PI)
	if progress > 1.0:
		progress = 1.0
	
	$Label.text = "Progress: " + str(round(progress * 100)) + "%"

func calculate_traced_length():
	var length = 0.0
	for i in range(1, len(traced_points)):
		length += (traced_points[i] - traced_points[i-1]).length()
	return length

func calculate_theoretical_circumference():
	return PI * diameter

func display_final_circumference():
	# Calculate theoretical circumference in centimeters
	var theoretical_circumference = calculate_theoretical_circumference() / pixels_per_cm
	$Label.text = "Tracing Complete! Circumference: " + str(round(theoretical_circumference * 10) / 10) + " cm"
	is_tracing = false
	circumference_displayed = true
	progress = 1.0  # Set progress to full

func set_diameter(new_diameter_cm):
	# Convert diameter from cm to pixels for internal calculations
	diameter = float(new_diameter_cm) * pixels_per_cm
	traced_points.clear()
	progress = 0.0
	is_tracing = false
	start_point = null
	draw_circle_outline()
	$Label.text = "Ready to trace..."

func _on_line_edit_text_changed(new_text):
	# Handle LineEdit text input (expecting centimeters)
	if new_text.is_valid_float():
		var value = float(new_text)
		if value > 0:  # Ensure diameter is positive
			set_diameter(value)  # Value is in centimeters
		else:
			$Label.text = "Please enter a positive number"

func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/cutscene_1.tscn")
