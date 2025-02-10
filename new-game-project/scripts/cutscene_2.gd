extends Node2D


@onready var label = $RichTextLabel
@onready var next_button = $Next
@onready var previous_button = $Previous
@onready var audio_player = $AudioStreamPlayer2D


var dialogue_lines = [
	"[center][color=white]हिरवा ठिपका (स्टार्ट पॉईंट) आणि लाल ठिपका (एंड पॉईंट) हलवताना काय होते हे तुम्ही पहिलका?
	
	जसे तुम्ही वर्तुळावर हे बिंदू समायोजित करता, तसंच महा आणि लघु चाप गतिशीलपणे हायलाइट केलं जातं.
	कन्फर्म बटण दाबल्यानंतर, संदर्भ म्हणून लाल-छायांकित क्षेत्राचा वापर करून अंतिम उत्तर निश्चित केले जाते.
	हे निर्धारित करते की हायलाइट आर्क (लाल रंगात) मेजर आर्क किंवा मायनर आर्क म्हणून वर्गीकृत केले गेले आहे की नाही.
	
	हे असे का घडत होते ही मुख्य संकल्पना समजून घेऊया.",
	"[center][font_size=28]मोठे आणि लहान चाप  समजून घेणे[/font_size][/center]

	जीवा **AB** वर्तुळाला दोन भागांमध्ये विभागतो:
		- लहान भागाला **लघु चाप** म्हणतात, तो पुढीलप्रमाणे दर्शविला जातो: [color=green]कंस AXB[/color].
		- मोठ्या भागाला **दीर्घ चाप** म्हणतात, तो पुढीलप्रमाणे दर्शविला जातो: [color=red]कंस AYB[/color].

	उदाहरणार्थ, पिझ्झा कल्पना करा! तुम्ही त्याचा एक तुकडा (कंस **AXB**) कापला तर तो पिझ्झाच्या लहान भागाला म्हणजेच **लघु चाप** म्हणतात. उरलेला पिझ्झाचा भाग (कंस **AYB**) **दीर्घ चाप** म्हणून ओळखला जातो. 
	[center][img=200]res://assets/diagram1.png[/img][/center]",
	
	"[font_size=28]Key Concept:[/font_size]
	- **अर्धवृत्तापेक्षा (अर्धगोलापेक्षा) लहान असलेल्या वक्राला** **लघु चाप** म्हणतात.  
	- **अर्धवृत्तापेक्षा मोठ्या वक्राला** **दीर्घ चाप/महाचाप** म्हणतात.
	
	[center][img=200]res://assets/diagram2.png[/img][/center]
	
	[font_size=28][b]Corresponding Arcs:[/b][/font_size]
	जर कोणत्याही वर्तुळाच्या दोन वक्रांनी समान टोकं सामायिक केली आणि एकत्र येऊन संपूर्ण वर्तुळ तयार केले, तर त्यांना संबंधित वक्र (Corresponding Arcs) म्हणतात. उदाहरणार्थ:
	- **कंस AYB** आणि **कंस AXB** हे संबंधित वक्र आहेत कारण ते एकत्र येऊन संपूर्ण वर्तुळ तयार करतात.

	[center][font_size=32]अर्धवृत्तीय वक्र (Semicircular Arcs):[/font_size][/center]
	- जेव्हा एखादी जीवा (chord) वर्तुळाच्या केंद्रातून जाते, तेव्हा ती वर्तुळाला दोन समान भागांमध्ये विभाजित करते. या वक्रांना **अर्धवृत्तीय वक्र** (*Semicircular Arcs*) म्हणतात.
	- उदाहरणार्थ, जर जीवा **RT** पिझ्झाच्या केंद्रातून जाणारा व्यास असेल, तर तो पिझ्झाला दोन समान भागांमध्ये विभाजित करतो. हे दोन्ही भाग **अर्धवृत्तीय वक्र** असतात.
	"
]

var audio_files = [
	"res://assets/Voices/Dialogue-4.mp3",
	"res://assets/Voices/Dialogue-5.mp3",
	"res://assets/Voices/Dialogue-6.mp3"
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
		play_voiceover(current_line)
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
	

func play_voiceover(index):
	if audio_player.playing:
		audio_player.stop()
	
	if index < audio_files.size():
		audio_player.stream = load(audio_files[index])
		audio_player.play()
