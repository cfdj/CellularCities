extends Control
##Exists to try and fix issues with TTS on web
@export var startScreen:String

func _ready():
	var string = "Welcome to Cellular City, press any button to continue"
	TTS.addText(string,true)
func _input(event):
	if(Input.is_anything_pressed()):
		get_tree().change_scene_to_file(startScreen);
