extends Node2D

@onready var input_diameter = $GameRoot/UI/Diameter
@onready var label_circumference = $GameRoot/UI/Circumference
@onready var label_formula = $GameRoot/UI/Formula
@onready var circle_sprite = $GameRoot/CircleSprite
@onready var start_marker = $GameRoot/StartMarker

var total_distance = 0.0
var last_position = Vector2()
var is_tracing = false
var diameter = 0.0
var points = []  # Stores traced points
var circle_center = Vector2()
var tracing_complete = false

func _ready():
	# Initialize UI elements
	circle_center = circle_sprite.global_position
	label_circumference.text = "Circumference: 0.00"
	label_formula.text = "Enter the diameter to begin tracing."
	input_diameter.text = ""
	input_diameter.text_submitted.connect(_on_diameter_entered)

func _on_diameter_entered(text):
	# Validate and set the diameter
	diameter = text.to_float()
	if diameter > 0:
		label_formula.text = "Trace the circle and return to the starting point to complete."
		start_marker.global_position = circle_center + Vector2(diameter / 2, 0)  # Place marker on the circle's edge
	else:
		label_formula.text = "Please enter a valid diameter."

func _process(delta):
	# Redraw the traced line
	if is_tracing:
		trace_circle()
	queue_redraw()

func _draw():
	# Draw the reference circle
	if diameter > 0:
		draw_circle(circle_center, diameter / 2, Color.GRAY, 2)
	
	# Draw the traced points
	if points.size() > 1:
		for i in range(points.size() - 1):
			draw_line(points[i], points[i + 1], Color.RED, 2)

func trace_circle():
	# Get current mouse position
	var current_position = get_global_mouse_position()
	
	if last_position != Vector2():
		# Check if the mouse is near the circle
		var radius = diameter / 2
		var distance_to_center = current_position.distance_to(circle_center)
		
		if abs(distance_to_center - radius) <= 10:  # Allow small margin of error
			# Calculate distance only if mouse moved significantly
			if last_position.distance_to(current_position) > 1:
				var segment_length = last_position.distance_to(current_position)
				total_distance += segment_length
				points.append(current_position)
				
				# Dynamically update circumference label
				label_circumference.text = "Circumference (Dynamic): %.2f".format(total_distance)
				
				# Check if the mouse is back at the start_marker
				if start_marker.global_position.distance_to(current_position) <= 10:
					if total_distance >= diameter * PI * 0.9:
						is_tracing = false
						tracing_complete = true
						label_circumference.text = "Circumference: %.2f".format(total_distance)
						label_formula.text = "Formula: Circumference = π × Diameter = %.2f".format(diameter * PI)
						trigger_cutscene()
		else:
			label_formula.text = "Keep tracing closer to the circle."
	
	last_position = current_position

func trigger_cutscene():
	# Trigger the next cutscene or event here
	print("Cutscene triggered!")
	label_formula.text = "Congratulations! You completed the circle!"

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and diameter > 0:
			# Start tracing
			is_tracing = true
			tracing_complete = false
			total_distance = 0.0
			points.clear()
			last_position = get_global_mouse_position()
			label_circumference.text = "Tracing started..."
			label_formula.text = "Trace along the circle."
		elif not event.pressed:
			# End tracing if not completed
			if not tracing_complete:
				is_tracing = false
				label_formula.text = "Tracing stopped. Total distance: %.2f".format(total_distance)
				points.clear()
