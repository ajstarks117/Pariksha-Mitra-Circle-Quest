extends Node2D


@onready var label = $RichTextLabel
@onready var next_button = $Next
@onready var previous_button = $Previous


var dialogue_lines = [
	"[center][color=white]Did you notice what happens when you move the green dot (start point) and the red dot (end point)?
	
	As you adjust these points on the circle, the major and minor arcs are dynamically highlighted.
	Upon pressing the Confirm button, the final answer is determined, using the red-shaded area as the reference. 
	This determines whether the highlighted arc (in red) is classified as the Major Arc or the Minor Arc.
	
	Let's understand the main concept why it was happening like this.",
	"[center][b][u]Understanding Major and Minor Arcs[/u][/b][/center]

	The chord **AB** divides the circle into two parts:
	- The smaller part is called the **Minor Arc**, represented as [color=green]arc AXB[/color].
	- The larger part is called the **Major Arc**, represented as [color=red]arc AYB[/color].

	For example, imagine a pizza! If you cut a slice (arc AXB), that slice is the minor part of the pizza. The rest of the pizza (arc AYB) becomes the major part. 🍕
	[center][img=200]res://assets/diagram1.png[/img][/center]",
	
	"[b]Key Concept:[/b]
	- The arc that is smaller than a semicircle (half-circle) is called the **Minor Arc**.
	- The arc larger than a semicircle is called the **Major Arc**.
	
	[center][img=200]res://assets/diagram2.png[/img][/center]
	
	[b]Corresponding Arcs:[/b]
	If two arcs of a circle share the same endpoints and together make a complete circle, they are called **Corresponding Arcs**. For example:
	- **Arc AYB** and **Arc AXB** are corresponding arcs because they form the whole circle.

	[center][i][u]Semicircular Arcs:[/u][/i][/center]
	- When a chord passes through the center of the circle, it divides the circle into two equal parts. These arcs are called **Semicircular Arcs**.
	- For example, if chord **RT** is the diameter of a pizza, cutting it through the center, both halves of the pizza are equal semicircular arcs.
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
	get_tree().change_scene_to_file("res://scenes/level_3.tscn")
	


func _on_previous_pressed() -> void:
	if current_line >0:
		current_line -= 1
		update_dialogue()
	
