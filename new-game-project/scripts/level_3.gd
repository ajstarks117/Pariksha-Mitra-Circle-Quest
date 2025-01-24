extends CanvasItem

var current_angle: float = 45.0
var circle_radius: float = 200.0

@onready var angle_slider = $Control/AngleSlider
@onready var angle_label = $Control/AngleLabel
@onready var arc_length_label = $Control/ArcLengthLabel

func _ready():
	# Set up slider range
	angle_slider.min_value = 0
	angle_slider.max_value = 360
	angle_slider.value = current_angle
	
	# Connect slider signal
	angle_slider.connect("value_changed",Callable( self, "_on_angle_changed"))
	
	# Initial visualization update
	_update_angle_visualization()

func _on_angle_changed(value: float):
	current_angle = value
	_update_angle_visualization()

func _update_angle_visualization():
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
	draw_arc(center, circle_radius, 0, 2*PI, 100, Color.WHITE, 2)
	
	# Draw angle segment
	var angle_rad = deg_to_rad(current_angle)
	var end_point = Vector2(
		center.x + circle_radius * cos(angle_rad),
		center.y - circle_radius * sin(angle_rad)
	)
	
	# Draw blue segment
	draw_line(center, end_point, Color.YELLOW, 3)
	
	# Create polygon for angle segment
	var polygon = PackedVector2Array([
		center,
		Vector2(center.x + circle_radius, center.y),
		end_point
	])
	draw_polygon(polygon, PackedColorArray([Color(0, 0, 1, 0.3)]))
