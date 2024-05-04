class_name menu extends Node

@export var startScreen:String

func quit():
	TTS.stop();
	get_tree().change_scene_to_file(startScreen);
