extends Node2D

@onready var circle_sprite = $CircleSprite
@onready var major_arc = $MajorArc
@onready var minor_arc = $MinorArc
@onready var start_marker = $Markers/StartMarker
@onready var end_marker = $Markers/EndMarker
@onready var formula_label = $UI/FormulaLabel
@onready var feedback_label = $UI/FeedbackLabel
@onready var confirm_button = $UI/ConfirmButton
@onready var major_panel = $PanelContainer/GridContainer/ColorRect
@onready var minor_panel = $PanelContainer/GridContainer/ColorRect2

var circle_center
var radius
var red_color = Color(1, 0, 0, 0.3)  # Semi-transparent red
var blue_color = Color(0, 0, 1, 0.3)  # Semi-transparent blue

func _ready():
	circle_center = circle_sprite.global_position
	radius = circle_sprite.texture.get_size().x / 2
	formula_label.text = "चाप निवडण्यासाठी मार्करला दुसऱ्या जाग्यावर न्या."
	feedback_label.text = ""
	confirm_button.connect("pressed", Callable(self, "_on_confirm_button_pressed"))
	
	# Set initial colors for the arcs
	minor_arc.color = red_color
	major_arc.color = blue_color

func _process(_delta):
	update_arcs()

func update_arcs():
	var start_angle = (start_marker.global_position - circle_center).angle()
	var end_angle = (end_marker.global_position - circle_center).angle()
	
	# Calculate the angle difference
	var angle_diff = end_angle - start_angle
	if angle_diff < 0:
		angle_diff += TAU
	
	# Calculate minor arc points
	var minor_points = [circle_center]
	var current_angle = start_angle
	var steps = 50
	for i in range(steps + 1):
		var t = float(i) / steps
		var angle = start_angle + angle_diff * t
		var point = circle_center + Vector2(cos(angle), sin(angle)) * radius
		minor_points.append(point)
	minor_points.append(circle_center)
	minor_arc.polygon = PackedVector2Array(minor_points)
	
	# Calculate major arc points
	var major_points = [circle_center]
	var major_angle_diff = TAU - angle_diff
	for i in range(steps + 1):
		var t = float(i) / steps
		var angle = end_angle + major_angle_diff * t
		var point = circle_center + Vector2(cos(angle), sin(angle)) * radius
		major_points.append(point)
	major_points.append(circle_center)
	major_arc.polygon = PackedVector2Array(major_points)
	
	# Calculate arc lengths
	var minor_arc_length = radius * angle_diff
	var major_arc_length = radius * (TAU - angle_diff)
	
	# Keep highlight colors consistent
	minor_arc.color = red_color
	major_arc.color = blue_color
	
	# Swap panel colors based on which arc is selected
	if minor_arc_length > major_arc_length:
		major_panel.color = red_color
		minor_panel.color = blue_color
	else:
		major_panel.color = blue_color
		minor_panel.color = red_color
	
	feedback_label.text = " लघु चाप लांबी: %.2f\nमहाचाप लांबी: %.2f" % [minor_arc_length, major_arc_length]

func _on_confirm_button_pressed():
	var start_angle = (start_marker.global_position - circle_center).angle()
	var end_angle = (end_marker.global_position - circle_center).angle()
	
	var angle_diff = end_angle - start_angle
	if angle_diff < 0:
		angle_diff += TAU
		
	var minor_arc_length = radius * angle_diff
	var total_circumference = TAU * radius

	if minor_arc_length < total_circumference / 2:
		formula_label.text = "आपण निवडले लघु चाप!"
	else:
		formula_label.text = "आपण निवडले महाचाप!"


func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/cutscene_2.tscn")
