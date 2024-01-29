class_name LevelLoader extends Node

@export var levels:Array[String];

func loadLevel(levelNum:int):
	if(levelNum<levels.size()):
		get_tree().change_scene_to_file(levels[levelNum]);
