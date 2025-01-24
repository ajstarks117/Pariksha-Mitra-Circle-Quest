extends Line2D

func _ready():
	var circle_center = Vector2(200, 200)  # Center of the circle
	var radius = 150                       # Radius of the circle
	var points_count = 100                 # Number of points in the circle

	for i in range(points_count):
		var angle = i * (2 * PI / points_count)
		var point = circle_center + Vector2(radius * cos(angle), radius * sin(angle))
		add_point(point)
