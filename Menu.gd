class_name menu extends Node

@export var startScreen:String
func _input(event):
	if event.is_action_pressed("Quit"):
		quit();

func quit():
	TTS.stop();
	get_tree().change_scene_to_file(startScreen);
