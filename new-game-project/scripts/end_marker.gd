extends Marker2D

var dragging = false
var circle_center: Vector2
var radius: float

func _ready():
	# Enable mouse input processing
	set_process_input(true)
	# Wait a frame to ensure parent is ready
	await get_tree().process_frame
	# Get the circle's properties from the parent node
	var parent = get_parent().get_parent()  # Level2 node
	if parent:
		circle_center = parent.circle_sprite.global_position
		radius = parent.radius
	else:
		push_error("Could not find parent node")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos = get_global_mouse_position()
			var marker_pos = global_position
			# Increased the click detection area slightly for easier interaction
			if event.pressed and mouse_pos.distance_to(marker_pos) < 25:
				dragging = true
			else:
				dragging = false
	
	elif event is InputEventMouseMotion and dragging:
		var mouse_pos = get_global_mouse_position()
		# Calculate the vector from circle center to mouse position
		var to_mouse = mouse_pos - circle_center
		# Normalize and scale by radius to ensure marker stays on circumference
		global_position = circle_center + to_mouse.normalized() * radius
