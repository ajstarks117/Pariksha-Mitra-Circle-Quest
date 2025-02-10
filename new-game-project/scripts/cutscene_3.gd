extends Node2D


@onready var label = $RichTextLabel
@onready var next_button = $Next
@onready var previous_button = $Previous
@onready var audio_player = $AudioStreamPlayer2D


var dialogue_lines = ["[center]मागील स्तरावरून संकल्पना जाणून घेऊया!

जेव्हा तुम्ही स्लायडर हलवता, तेव्हा मध्य कोण बदलतो आणि त्यासोबतच वक्राची लांबी देखील बदलते. मोठा मध्य कोण मोठा वक्र तयार करतो, तर लहान कोण लहान वक्र तयार करतो.",

	"[center][font_size=28]मध्य कोण आणि वक्राचे मापन[/font_size][center]

आकृतीत, **'O'** हा **angle AOB** चा शीर्षबिंदू आहे. ज्या कोणाचा शीर्षबिंदू वर्तुळाच्या केंद्रात असतो, त्याला **मध्य कोण** (*Central Angle*) म्हणतात.

[img=400]res://assets/diagram3.png[/img]

उदाहरणार्थ, मोठ्या गोल पिझ्झाची कल्पना करा. जर तुम्ही एखादा तुकडा ठेवला आणि त्याचा टोक वर्तुळाच्या (पिझ्झाच्या) मध्यभागी असेल, तर त्या टोकाशी तयार होणारा कोण **मध्य कोण** (*Central Angle*) असेल.

आकृतीत, **angle AOB** हा **त्याला समोर असलेल्या वक्राचा (Arc AB) मध्य कोण** आहे. [color=green]arc AZB[/color].

एखाद्या वक्राने केंद्रावर तयार केलेल्या कोनाच्या मापनाला **त्या वक्राचा मध्य कोण** (*Central Angle*) मानले जाते.[color=red]कंसाचे माप[/color] स्वत:.",

"[center][font_size=28]लघुकंसाचे माप[/font_size]
शेजारील आकृतीमध्ये angle AOQ या केंद्री कोनाचे मापन 70° आहे.
[color=green]लघुकंस AYQ[/color] चे माप 70° आहे. 
हे असे लिहिले जाईल:
m(कंस  AYQ) = 70°.

[img=300]res://assets/diagram4.png[/img]

[font_size=28]विशालकंसाचे माप[/font_size]
[color=purple]विशालकंसाचे माप[/color] याचे मापन खालील सूत्राने शोधले जाते:

विशालकंसाचे माप = 360° - संगत लघुकंसाचे माप[/center]",

"[center]उदाहरणार्थ, जर [color=green]लघुकंस XYQ चे माप = 70° आहे[/color], तर:

[color=gold]विशालकंसाचे माप XYZ = 360° - 70° = 290°[/color].

[font_size=24]उदाहरणार्थ: [/font_size]
मोठ्या गोल पिझ्झाची कल्पना करा, जो 8 समसमान तुकड्यांमध्ये कापलेला आहे. प्रत्येक तुकडा तयार करणारा मध्य कोण असा असेल:

[b]360° ÷ 8 = 45°[/b]

- मध्य कोण [color=green]दोन तुकड्यां[/color] दरम्यान असतो आणि तो [color=red]लघु कंस[/color] दर्शवतो, जो त्या दोन तुकड्यांना जोडतो. उदाहरणार्थ, एका तुकड्यामुळे लघु कंस 45° तयार होतो.

- आता समजा, तुम्ही [color=green]4 तुकडे[/color] (अर्धा पिझ्झा) खल्ला, तर उरलेला [color=purple]विशालकंस[/color] संपूर्ण वर्तुळाचा उर्वरित भाग असेल. कारण:

4 तुकडे = 180° (45° × 4)

दीर्घ कंस हा लघु कंसाचा पूरक असतो.

विशालकंसाचे माप  = 360° - 180° = 180°.",

"[center]म्हणून, खाल्लेला भाग (4 तुकडे) [color=red]लघु कंस[/color] असून त्याचे मापन 180° आहे, आणि उरलेला भाग [color=purple]दीर्घ कंस[/color] असून त्याचेही मापन 180° आहे.

पिझ्झाची कल्पना करून, तुम्ही सहज **[color=blue]मध्य कोन[/color]**, **[color=green]लघु कंस[/color]**, आणि **[color=purple]दीर्घ कंस[/color]** यांच्यातील संबंध समजू शकता.
"
]

var audio_files = [
	"res://assets/Voices/Dialogue-7.mp3",
	"res://assets/Voices/Dialogue-8.mp3",
	"res://assets/Voices/Dialogue-9.mp3",
	"res://assets/Voices/Dialogue-10.mp3",
	"res://assets/Voices/Dialogue-11.mp3"
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
	get_tree().change_scene_to_file("res://scenes/endscreen.tscn")
	


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
