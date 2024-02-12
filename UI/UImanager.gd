class_name UIManager extends CanvasLayer

@export var level:LevelManager;
@export var buildingMenu:BuildingMenu;
@export var scoreDisplay:ScoreDisplay;
@export var buildingList:BuildingList;
@export var nextLevel:Button;
func setBuildingMenu():
	buildingMenu.setDisplays(level.listOfBuildings,level.allBuildings);

func _on_guide_pressed():
	level.playing = false;
	buildingMenu.visible = true;
	TTS.guide(level.listOfBuildings,level)
func _on_guide_close():
	TTS.stop()
	buildingMenu.visible = false;
	level.playing = true;

func updateScore(map:TileMap,buildings:Array[Vector2i]):
	scoreDisplay.updateScore(map,buildings);

func setBuildingList(buildings:Array[Building]):
	buildingList.setItemList(buildings);

func popBuildingList():
	buildingList.popItemList();

func pushBuildingList(building:Building):
	buildingList.pushItemList(building);

func showNextlevelButton():
	nextLevel.visible = true;

func _on_next_level_button_pressed():
	TTS.stop();
	Loader.nextLevel();



func _on_undo_pressed():
	if(level.playing):
		level.undo();		

func _input(event):
	if(event.is_action("Guide")):
		if(buildingMenu.visible):
			_on_guide_close()
		else:
			_on_guide_pressed()
