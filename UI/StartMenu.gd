extends Control

@export var startMenu:Control
@export var levelSelect:Control
@export var settings:Control
@export var startButton:Control

func _ready():
	##If the game is openning for the first time
	if(Menu.firstOpen):
		_on_settings_pressed()
		Menu.firstOpen = false;
	else:
		startButton.grab_focus()
func startGame():
	##TTS.stop()
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
		var string  = current.text + getPositionString(current)
		TTS.addText(string,true)

func _on_settings_closed_button_pressed():
	TTS.stop()
	settings.visible = false;
	startMenu.visible = true;
	startButton.grab_focus()

func _on_settings_pressed():
	TTS.stop()
	settings.visible = true;
	startMenu.visible = false;

func getPositionString(current:Control) ->String:
	var MenuChildren = current.get_parent().get_children()
	var focusables:Array[Control]
	for f in MenuChildren:
		if((f as Control).focus_mode != FOCUS_NONE):
			focusables.append(f);
	var string = " " +str(focusables.find(current)+1) + " of " + str(focusables.size())
	return string
