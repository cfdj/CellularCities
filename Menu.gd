class_name menu extends Node

@export var startScreen:String
var firstOpen = true;
func quit():
	TTS.stop();
	get_tree().change_scene_to_file(startScreen);
