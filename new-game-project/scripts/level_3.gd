extends Node2D
var current_angle: float = 45.0
var circle_radius: float = 200.0
@onready var angle_slider = $Control/AngleSlider
@onready var angle_label = $Control/AngleLabel
@onready var arc_length_label = $Control/ArcLengthLabel
@onready var background = $ColorRect
func _ready():
	# Set up background
	var viewport_size = get_viewport_rect().size
	background.size = viewport_size
	background.color = Color.PLUM
	
	# Set z-index to ensure proper drawing order
	background.z_index = -1  # Put background behind
	self.z_index = 1        # Put drawing node in front
	
	# Set up slider range
	angle_slider.min_value = 0
	angle_slider.max_value = 360
	angle_slider.value = current_angle
	
	# Connect slider signal
	angle_slider.connect("value_changed", Callable(self, "_on_angle_changed"))
	
	# Initial visualization update
	update_angle_visualization()
func _on_angle_changed(value: float):
	current_angle = value
	update_angle_visualization()
func update_angle_visualization():
	# Update labels
	angle_label.text = "Central Angle: %.1f°" % current_angle
	
	# Calculate arc length (circumference * (angle/360))
	var arc_length = 2 * PI * circle_radius * (current_angle / 360.0)
	arc_length_label.text = "Arc Length: %.2f" % arc_length
	
	# Request a redraw
	queue_redraw()
func _draw():
	# Get the size of the viewport/window
	var viewport_size = get_viewport_rect().size
	
	# Calculate center of the screen
	var center = viewport_size / 2
	
	# Draw full circle outline
	draw_arc(center, circle_radius, 0, 2*PI, 100, Color.WHITE, 3)
	
	# For counterclockwise, we start from the top (90 degrees) 
	# and go counterclockwise towards 0 degrees
	var start_angle = deg_to_rad(0)  # Start from top (90 degrees)
	var end_angle = start_angle - deg_to_rad(current_angle)  # Subtract angle to go counterclockwise
	
	# Draw the filled arc
	draw_arc(center, circle_radius, start_angle, end_angle, 100, Color(0, 0, 1, 0.3), 20)
	
	# Fill the area between the arc and center
	var points = PackedVector2Array()
	points.push_back(center)  # Start at center
	
	# Add points along the arc
	var num_points = 32
	for i in range(num_points + 1):
		var t = float(i) / float(num_points)
		var angle = start_angle + t * (end_angle - start_angle)
		var point = center + Vector2(
			circle_radius * cos(angle),
			circle_radius * sin(angle)
		)
		points.push_back(point)
	
	# Draw the filled area
	draw_colored_polygon(points, Color(0, 0, 1, 0.3))
	
	# Draw radius line to show starting point (90 degrees)
	draw_line(center, center + Vector2(0, 0), Color.WHITE, 2)
	
	# Draw radius line to show current angle
	var end_point = center + Vector2(
		circle_radius * cos(end_angle),
		circle_radius * sin(end_angle)
	)
	draw_line(center, end_point, Color.YELLOW, 2)


func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/cutscene_3.tscn")
