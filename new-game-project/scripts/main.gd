extends Node2D

@onready var input_diameter = $GameRoot/UI/Diameter
@onready var label_circumference = $GameRoot/UI/Circumference
@onready var label_formula = $GameRoot/UI/Formula
@onready var circle_sprite = $GameRoot/CircleSprite
@onready var start_marker = $GameRoot/StartMarker
@onready var circle_outline = $GameRoot/CircleOutline

var total_distance = 0.0
var last_position = Vector2()
var is_tracing = false
var diameter = 0.0
var points = []
var circle_center = Vector2()
var tracing_complete = false

func _ready():
	# Initialize UI elements
	circle_center = circle_sprite.global_position
	label_circumference.text = "Circumference: 0.00 cm"
	label_formula.text = "Enter the diameter to begin tracing."
	input_diameter.text = ""
	start_marker.visible = false
	
	# Setup circle outline properties
	circle_outline.default_color = Color(0.7, 0.7, 0.7, 0.3)
	circle_outline.width = 8.0  # Increased line width for better visibility
	
	# Connect to both text_submitted and text_changed signals
	input_diameter.text_submitted.connect(_on_diameter_entered)
	input_diameter.text_changed.connect(_on_diameter_changed)

func _on_diameter_changed(new_text: String):
	# Update UI feedback immediately as user types
	if new_text.is_empty():
		label_formula.text = "Please enter a diameter value."
	elif !new_text.is_valid_float():
		label_formula.text = "Please enter a valid number."

func _on_diameter_entered(text: String):
	if text.is_empty():
		label_formula.text = "Please enter a diameter value."
		reset_circle()
		return
		
	var new_diameter = text.to_float()
	if new_diameter > 0:
		diameter = new_diameter
		label_formula.text = "Trace the circle and return to the starting point to complete."
		start_marker.global_position = circle_center + Vector2(diameter / 2, 0)
		start_marker.visible = true
		update_circle_outline()
		print("Diameter set to: ", diameter) # Debug print
	else:
		label_formula.text = "Please enter a valid positive number."
		reset_circle()

func reset_circle():
	circle_outline.clear_points()
	start_marker.visible = false
	diameter = 0.0
	points.clear()
	total_distance = 0.0
	label_circumference.text = "Circumference: 0.00 cm"

func update_circle_outline():
	circle_outline.clear_points()
	if diameter <= 0:
		return
		
	var radius = diameter / 2
	var points_count = 128  # Increased point count for smoother circle
	
	for i in range(points_count + 1):
		var angle = i * (2 * PI / points_count)
		var point = circle_center + Vector2(radius * cos(angle), radius * sin(angle))
		circle_outline.add_point(point)

func _process(_delta):
	if is_tracing:
		trace_circle()
	queue_redraw()

func _draw():
	if points.size() > 1:
		for i in range(points.size() - 1):
			draw_line(points[i], points[i + 1], Color(1, 0, 0, 0.8), 15.0)  # Increased line width for tracing

func trace_circle():
	var current_position = get_global_mouse_position()
	
	if last_position == Vector2.ZERO:
		last_position = current_position
		points.append(current_position)  # Add first point
		return
	
	var radius = diameter / 2
	var distance_to_center = current_position.distance_to(circle_center)
	var tolerance = 35.0  # Increased tolerance for easier tracing
	var inner_radius = radius - tolerance
	var outer_radius = radius + tolerance
	
	# Check if the mouse is within the tracing area (between inner and outer radius)
	if distance_to_center >= inner_radius and distance_to_center <= outer_radius:
		if current_position.distance_to(last_position) > 1.0:
			points.append(current_position)
			var segment_length = last_position.distance_to(current_position)
			total_distance += segment_length
			
			# Calculate progress based on theoretical circumference
			var theoretical_circumference = PI * diameter
			var progress = (total_distance / theoretical_circumference) * 100
			label_circumference.text = "Progress: %.1f%% (Length: %.2f cm)" % [progress, total_distance]
			
			# More forgiving completion check
			if points.size() > 10:
				var start_tolerance = 40.0  # Increased tolerance for completion
				var distance_to_start = current_position.distance_to(points[0])
				if distance_to_start <= start_tolerance:
					complete_tracing()
	else:
		# Visual feedback for staying in bounds
		if distance_to_center < inner_radius:
			label_formula.text = "Move outward, you're too close to the center!"
		else:
			label_formula.text = "Move inward, you're too far from the circle!"
	
	last_position = current_position

func complete_tracing():
	is_tracing = false
	tracing_complete = true
	var theoretical_circumference = PI * diameter
	label_circumference.text = "Measured: %.2f cm (Theoretical: %.2f cm)" % [total_distance, theoretical_circumference]
	label_formula.text = "Tracing complete! Error: %.1f%%" % (abs(total_distance - theoretical_circumference) / theoretical_circumference * 100)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and diameter > 0:
			# Start tracing
			is_tracing = true
			tracing_complete = false
			total_distance = 0.0
			points.clear()
			last_position = Vector2.ZERO
			label_circumference.text = "Tracing started..."
			label_formula.text = "Trace along the circle outline."
		elif !event.pressed:
			# Stop tracing if not completed
			if !tracing_complete:
				is_tracing = false
				label_formula.text = "Tracing stopped. Try again!"
				points.clear()
				total_distance = 0.0
