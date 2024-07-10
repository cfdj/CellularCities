class_name UIManager extends CanvasLayer

@export var level:LevelManager;
@export var buildingMenu:BuildingMenu;
@export var scoreDisplay:ScoreDisplay;
@export var buildingList:BuildingList;
@export var nextLevel:Button;

@export var settingMenu:SettingMenu;
var settingsOpen = false;
func setBuildingMenu():
	buildingMenu.setDisplays(level.buildingsForGuide,level.allBuildings);

func _on_guide_pressed():
	TTS.stop()
	level.playing = false;
	buildingMenu.visible = true;
	TTS.guide(level.buildingsForGuide,level)
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
	nextLevel.grab_focus()
	scoreDisplay.levelEnd()
	TTS.addText("Next level",false)
func _on_next_level_button_pressed():
	TTS.stop();
	Loader.nextLevel();


func _on_undo_pressed():
	if(level.playing):
		level.undo();		

func _input(event):
	if(event.is_action_pressed("Guide")):
		if(buildingMenu.visible):
			_on_guide_close()
		else:
			_on_guide_pressed()
	if(event.is_action_pressed("Quit")):
		if(settingsOpen):
			closeMenu();
		else:
			openMenu();


func _on_quit_button_pressed():
	Menu.quit();

func openMenu():
	TTS.stop()
	settingMenu.visible = true;
	settingsOpen = true;
	buildingMenu.visible = false;
	level.playing = false;
##	settingMenu._on_visibility_changed()
	
func closeMenu():
	settingMenu.visible = false;
	settingsOpen = false;
	level.playing = true;
	TTS.stop()

func _on_menu_button_pressed():
	openMenu();
	


func _on_MenuClose_button_pressed():
	closeMenu();
