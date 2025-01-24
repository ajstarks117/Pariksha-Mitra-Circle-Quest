extends Node2D

@onready var center = $Center
@onready var start_marker = $Markers/StartMarker
@onready var end_marker = $Markers/EndMarker
@onready var major_arc = $MajorArc
@onready var minor_arc = $MinorArc

var circle_radius = 100.0  # Adjust this to match your circle's radius
var active_marker = null  # Currently active marker for dragging

func _ready():
	# Ensure nodes are properly initialized
	if not start_marker or not end_marker:
		print("Error: StartMarker or EndMarker is not properly assigned!")
		return

	# Initialize markers on the circumference
	place_marker(start_marker, 0)  # Place at 0 degrees
	place_marker(end_marker, PI / 2)  # Place at 90 degrees (PI/2 radians)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Check if the mouse is close to either marker
			if start_marker and start_marker.global_position.distance_to(event.position) < 10:
				active_marker = start_marker
			elif end_marker and end_marker.global_position.distance_to(event.position) < 10:
				active_marker = end_marker
		else:
			# Stop dragging when mouse button is released
			active_marker = null
	elif event is InputEventMouseMotion and active_marker:
		# Drag the active marker along the circumference
		drag_marker(active_marker, event.position)

func place_marker(marker, angle):
	# Place the marker at a specific angle on the circle's circumference
	if marker:
		var position = Vector2(cos(angle), sin(angle)) * circle_radius
		marker.global_position = center.global_position + position
	else:
		print("Error: Marker is null when attempting to place it.")

func drag_marker(marker, mouse_position):
	# Calculate the direction vector from the center to the mouse position
	if marker:
		var direction = mouse_position - center.global_position
		direction = direction.normalized() * circle_radius  # Constrain to radius
		marker.global_position = center.global_position + direction

		# Update arcs dynamically based on marker positions
		update_arcs()
	else:
		print("Error: Active marker is null while dragging.")

func update_arcs():
	# Ensure markers are valid before calculating
	if not start_marker or not end_marker:
		print("Error: One or both markers are null in update_arcs.")
		return

	# Calculate angles for start and end markers
	var start_angle = (start_marker.global_position - center.global_position).angle()
	var end_angle = (end_marker.global_position - center.global_position).angle()

	# Ensure angles are in the range [0, 2*PI]
	start_angle = wrapf(start_angle, 0, TAU)  # TAU is 2*PI
	end_angle = wrapf(end_angle, 0, TAU)

	# Determine major and minor arcs based on angles
	var arc_angle = abs(end_angle - start_angle)
	if arc_angle > PI:
		arc_angle = TAU - arc_angle

	# Update UI or visuals here (e.g., change arc visibility, label updates, etc.)
	$UI.FeedbackLabel.text = "Arc Angle: %.2f radians".format(arc_angle)
