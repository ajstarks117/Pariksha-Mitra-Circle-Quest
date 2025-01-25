extends Node2D


@onready var label = $RichTextLabel
@onready var next_button = $Next


var dialogue_lines = [
	"[center][color=white]Hello! Did you notice something interesting in the previous level? When you traced the circle's circumference and provided an input for the diameter, the circle changed—and so did its circumference!
	Let’s dive deeper and uncover the concept behind this phenomenon.
	[b][i]Understanding the Relationship Between the Circumference and the Diameter[/i][/b]
	The circumference and diameter of a circle share a fascinating connection that is fundamental to geometry. 
	Are you ready to explore this relationship? Let's learn together!",
	"[center][color=white]The ratio of a circle's circumference to its diameter is a constant number, approximately 3.14, known as π (pi).[/color][/center]
	[center][color=white]This ratio is the same for all circles, no matter how large or small, and is expressed as:
	[/color][/center]
	[center][color=white]Circumference (c) ÷ Diameter (d) = π[/color][/center]
	[center][color=white]In practice, we approximate π as 3.14 or 22/7, but it’s an irrational number, meaning it goes on forever without repeating![/color][/center]",
	"[center][color=white]Now, to calculate the circumference of a circle, if we know the diameter (d), we can use the formula:[/color][/center]
	[center][b][i][color=white]c = π × d[/color][/i][/b][/center]
	[center][color=white]But if we know the radius (r), we can also use the formula:[/color][/center]
	[center][b][i][color=white]c = 2 × π × r[/color][/i][/b][/center]
	[center][color=white]So, by understanding the relationship between the diameter and radius, and the special number π, we can calculate the circumference of any circle![/color][/center]"
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
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")
	


func _on_previous_pressed() -> void:
	if current_line > 0:
		current_line -= 1
		update_dialogue()
