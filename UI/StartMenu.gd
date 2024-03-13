extends Control

@export var startMenu:Control
@export var levelSelect:Control
@export var settings:Control
@export var startButton:Control
func _ready():
	pass;

func startGame():
	TTS.stop()
	Loader.loadLevel(0);

func quit():
	get_tree().quit();	


func _on_back_button_pressed():
	TTS.stop()
	levelSelect.visible = false;
	startMenu.visible = true;
	startButton.grab_focus();

func _on_level_select_pressed():
	TTS.stop()
	levelSelect.visible = true;
	startMenu.visible = false;

func speakFocus():
	var current:Button = get_viewport().gui_get_focus_owner()
	if(current !=null && current.visible):
		TTS.addText(current.text)

func _on_settings_closed_button_pressed():
	TTS.stop()
	settings.visible = false;
	startMenu.visible = true;
	startButton.grab_focus()



func _on_settings_pressed():
	TTS.stop()
	settings.visible = true;
	startMenu.visible = false;

