class_name LevelLoader extends Node

@export var levels:Array[String];
var currentLevel = 0;

func loadLevel(levelNum:int):
	if(levelNum<levels.size()):
		currentLevel = levelNum;
		get_tree().change_scene_to_file(levels[levelNum]);

func nextLevel():
	loadLevel(currentLevel+1);
