class_name LevelLoader extends Node

@export var levels:Array[String];
var currentLevel = 0;
@export var thanks:String;
func loadLevel(levelNum:int):
	if(levelNum<levels.size()):
		currentLevel = levelNum;
		get_tree().change_scene_to_file(levels[levelNum]);
	else:
		get_tree().change_scene_to_file(thanks);
func nextLevel():
	loadLevel(currentLevel+1);
