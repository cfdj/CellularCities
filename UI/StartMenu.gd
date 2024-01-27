extends Control

##Will also handle loading
@export var firstLevel:String

func startGame():
	get_tree().change_scene_to_file(firstLevel);

func quit():
	get_tree().quit();	
