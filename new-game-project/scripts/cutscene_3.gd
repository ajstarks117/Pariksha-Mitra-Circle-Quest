extends Node2D


@onready var label = $RichTextLabel
@onready var next_button = $Next
@onready var previous_button = $Previous


var dialogue_lines = ["[center]Let’s explore the concept from the previous level!

When you slide the slider, the central angle changes, and so does the arc length. A bigger central angle creates a longer arc, while a smaller angle creates a shorter arc.",
	"[center][b][u]Central Angle and the Measure of an Arc[/u][/b][center]
In the figure, 'O' is the vertex of angel AOB. An angle whose vertex is at the center of a circle is called a [color=blue]central angle[/color].

[img=400]res://assets/diagram3.png[/img]

For example, think of a big round pizza. If you place a slice with its tip at the center of the pizza, the angle formed at the tip is the central angle.

In the figure, angle AOB is the central angle corresponding to [color=green]arc AZB[/color].
The measure of the angle subtended at the center by an arc is considered to be the [color=red]measure of the arc[/color] itself.",

"[center][b][u]The Measure of a Minor Arc[/u][/b]
In the figure, the central angle AOY = 70°.
∴ The measure of the [color=green]minor arc AYQ[/color] is also 70°.
It is written as:
[b]m(arc AYQ) = 70°[/b].

[img=300]res://assets/diagram4.png[/img]

[b][u]The Measure of a Major Arc[/u][/b]
The measure of a [color=purple]major arc[/color] is found using this formula:
[b]Measure of a major arc = 360° - Measure of the corresponding minor arc[/b][/center]",

"[center]For example, if the [color=green]minor arc XYQ = 70°[/color], then:
[b]Measure of major arc XYZ = 360° - 70° = 290°[/b].

[b][u]For Example: [/u][/b]
Imagine a large circular pizza cut into [b]8 equal slices[/b]. Each slice makes a central angle of:
[b]360° ÷ 8 = 45°[/b]

- The central angle between any [color=green]two slices[/color] corresponds to the [color=red]minor arc[/color] that connects those two slices. For example, one slice would subtend a minor arc of [b]45°[/b].
- Now, suppose you eat [color=green]4 slices[/color] of the pizza (half of it). The [color=purple]major arc[/color] left on the pizza is the rest of the circle. Since:
[b]4 slices = 180° (45° × 4)[/b]
The major arc is the complement of the minor arc:
[b]Measure of the major arc = 360° - 180° = 180°[/b].",

"[center]So, the eaten part (4 slices) corresponds to a [color=red]minor arc[/color] of 180°, and the leftover part corresponds to a [color=purple]major arc[/color] of 180°.

By visualizing the pizza, you can easily understand the relationship between [color=blue]central angles[/color], [color=green]minor arcs[/color], and [color=purple]major arcs[/color][/center]
	"
]

var current_line = 0 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_dialogue()
	next_button.connect("pressed", Callable(self, "_on_next_pressed"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_dialogue():
	if current_line < dialogue_lines.size():
		label.text = dialogue_lines[current_line]
	else:
		end_cutscene()
		
		
func _on_next_pressed() -> void:
	current_line += 1
	update_dialogue()



func end_cutscene():
	
	# Transition to the next part of the game
	get_tree().change_scene_to_file("res://scenes/endscreen.tscn")
	


func _on_previous_pressed() -> void:
	if current_line >0:
		current_line -= 1
		update_dialogue()
	
