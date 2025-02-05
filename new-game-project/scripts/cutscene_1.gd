extends Node2D


@onready var label = $RichTextLabel
@onready var next_button = $Next


var dialogue_lines = [
	"[center][color=white]नमस्कार! मागच्या लेव्हलमध्ये तुम्हाला काही इंटरेस्टिंग दिसलं का? जेव्हा आपण वर्तुळाचा परीघ शोधला आणि व्यासासाठी उत्तर प्रदान केले, तेव्हा वर्तुळ बदलले- आणि त्याचा परिघदेखील!
आपण खोलात जाऊन या घटनेमागची संकल्पना उलगडूया.

	[b][i]परीघ आणि व्यास यांचा संबंध समजून घेणे :[/i][/b]
	
	वर्तुळाचा परीघ आणि व्यास एक आकर्षक संबंध सामायिक करतात जो भूमितीसाठी मूलभूत आहे.
तुम्ही हे नातं एक्सप्लोर करायला तयार आहात का? आपण एकत्र शिकूया!",
	"[center][color=white]वर्तुळाच्या परीघाचे त्याच्या व्यासाशी असलेले गुणोत्तर एक स्थिर संख्या आहे, अंदाजे ३.१४, ज्याला π (पाई) म्हणून ओळखले जाते.[/color][/center]
	[center][color=white]हे गुणोत्तर सर्व वर्तुळांसाठी समान आहे, मग ते कितीही मोठे असो किंवा लहान असो, आणि ते अशा प्रकारे व्यक्त केले जाते:
	[/color][/center]
	[center][color=white]परीघ ÷ व्यास  = π[/color][/center]
	[center][color=white]व्यवहारात, आपण π अंदाजे ३.१४ किंवा २२/७ म्हणून गृहीत धरतो, परंतु ही एक अतार्किक संख्या आहे, म्हणजे ती पुनरावृत्ती न करता कायमचालू राहते![/color][/center]",
	"[center][color=white]आता, वर्तुळाचा परिघ मोजण्यासाठी, जर आपल्याला व्यास माहित असेल तर आपण सूत्र वापरू शकतो:[/color][/center]
	[center][b][i][color=white]परिघ = π × व्यास[/color][/i][/b][/center]
	[center][color=white]परंतु जर आपल्याला त्रिज्या माहित असेल तर आपण सूत्र देखील वापरू शकतो:[/color][/center]
	[center][b][i][color=white]c = २ × π × त्रिज्या[/color][/i][/b][/center]
	[center][color=white]त्यामुळे व्यास आणि त्रिज्या आणि π विशेष संख्या यांचा संबंध समजून घेऊन आपण कोणत्याही वर्तुळाचा परिघ मोजू शकतो![/color][/center]"
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
