class_name LevelManager extends Node

var level:int;
@export var map:TileMap;
@export var listOfBuildings:Array[Building];
var currentBuilding:Building;
var previousLocation:Vector2i;
var location:Vector2i;

var current:int = 0;
var listOfPlaced:Array[Vector2i];

var playRegion:Array[Vector2i];
var playRegionMarker = Vector2i(4,5);
var streetLocations = [Vector2i(0,3),Vector2i(1,3),Vector2i(0,4),Vector2i(1,4)]
var forestLocations = [Vector2i(5,0),Vector2i(4,1),Vector2i(5,1)]
var negativeHint = Vector2i(2,0);
var positiveHint = Vector2i(4,6);

@export_category("Animations")
@export var hatesAnimationSprite:PackedScene;

var playing = true;
static var mouse = false;

@export var ui:UIManager;
@export var allBuildings:Array[Building] ##An array of all buildings in ID order
var buildingsForGuide:Array[Building] ##All buildings which should be displayed in a levels guide
@export_category("Level setup details")
@export var forestLevel:bool
@export var levelDescription:String

##For camera Zoom
var camera:CameraZoom

func _ready():
	camera = get_node("%Camera2D")
	camera.level = self
	currentBuilding = listOfBuildings[current];
	playRegion = map.get_used_cells_by_id(2,0,playRegionMarker)
	for i in playRegion:
		map.erase_cell(2,i);
	setupUI();
	hint();
	level = Loader.levels.find(get_parent().get_parent().scene_file_path);
	if(!mouse):
		location = playRegion[0];
		previousLocation = playRegion[0];
		currentBuilding.cursor(map,location);
	TTS.stop()

	describeLevel(true);

func _physics_process(delta):
	if playing:
		if mouse:
			var mousePos = get_viewport().get_mouse_position();
			location = map.get_local_mouse_position();
			location = map.local_to_map(location);
		elif !mouse:
			##For when mouse is switched off
			if(!playRegion.has(location)):
				location = playRegion[0];
			var vertical = Vector2i(0,0)
			if(Input.is_action_just_pressed("Up")or Input.is_action_just_pressed("Down")):
				var value = Input.get_axis("Up","Down")
				if(value<0):
					value = -1;
				else:
					value = 1;
				vertical = Vector2i(Vector2i(0,1)*value)
			var horizontal =  Vector2i(0,0)
			if(Input.is_action_just_pressed("Left")or Input.is_action_just_pressed("Right")):
				var value = Input.get_axis("Left","Right")
				if(value<0):
					value = -1;
				else:
					value = 1;
				horizontal = Vector2i(Vector2i(1,0)*value);
			location += horizontal
			if(!playRegion.has(location)):
				location -= horizontal;
				var string = "City limit"
				TTS.addText(string,true)
			location += vertical
			if(!playRegion.has(location)):
				location -= vertical
				var string = "City limit"
				TTS.addText(string,true)
		if location != previousLocation:
			currentBuilding.clearCursor(map,previousLocation);
			print(location)
			print( get_viewport().get_mouse_position())
			if playRegion.has(location):
				currentBuilding.cursor(map,location);
				describeSquare(location);
				camera.move(map.to_global(map.map_to_local(location)))
			previousLocation = location;

func checkPlace(currentLocation):
	var valid = true;
	if !playRegion.has(currentLocation):
		valid = false
	for i in currentBuilding.relevantTiles(map,currentLocation):
		var n = map.get_cell_tile_data(0,i);
		if(n != null):
			if currentBuilding.checkIndividual(map,currentLocation,i,playRegion) == Building.squareValidity.HATES:
				valid = false;
				cantPlaceAnimation(i);
	if(valid):
		place(currentLocation);
	else:
		SoundEffects.cantSound();
func place(currentLocation):
	var placing = currentBuilding;
	currentBuilding.clearCursor(map,currentLocation);
	clearHint();
	##setting a temporary building
	placing.place(map,currentLocation)
	SoundEffects.buildingSound(placing.id)
	listOfPlaced.append(currentLocation);
	TTS.placeBuilding(placing,currentLocation)
	current+=1;
	ui.popBuildingList();
	if(current<listOfBuildings.size()):
		currentBuilding = listOfBuildings[current];
		TTS.addText("Next building is",false);
		TTS.readBuilding(currentBuilding);
		hint();
	else:
		finishLevel();
func undo():
	if current >0:
		get_viewport().gui_release_focus()
		current -=1;
		currentBuilding = listOfBuildings[current];
		var clearLocation = listOfPlaced.pop_back();
		currentBuilding.undo(map,clearLocation);
		TTS.undoBuilding(currentBuilding,clearLocation)
		ui.pushBuildingList(currentBuilding);
		if(mouse):
			var mousePos = get_viewport().get_mouse_position();
			location = map.to_local(mousePos);
			location = map.local_to_map(mousePos);
			currentBuilding.clearCursor(map,location);
		if playRegion.has(location):
			currentBuilding.cursor(map,location);
		clearHint();
		hint();
func finishLevel():
	camera.zoomOut();
	camera.zoomOut();
	playing = false;
	TTS.stop();
	SoundEffects.levelDoneSound();
	await get_tree().create_timer(0.2).timeout
	ui.showNextlevelButton();
	ui.updateScore(map,playRegion);
	for i in playRegion:
		if(map.get_cell_tile_data(0,i) ==null):
			var fillLocation
			if(forestLevel):
				fillLocation = forestLocations[randi()%forestLocations.size()]
			else:
				fillLocation =streetLocations[randi() % streetLocations.size()];
			map.set_cell(0,i,0,fillLocation)
			await get_tree().create_timer(0.2).timeout
	TTS.addText("Total score: " +str(ui.scoreDisplay.totalScore),true)
func hint():
	for t in playRegion:
		if(map.get_cell_tile_data(0,t) == null):
			var validity:Building.squareValidity = currentBuilding.checkPlaceable(map,t,playRegion);
			match validity:
				Building.squareValidity.LIKES:
					map.set_cell(2,t,0,positiveHint);
				Building.squareValidity.HATES:
					map.set_cell(2,t,0,negativeHint);
func clearHint():
	for i in playRegion:
		map.erase_cell(2,i);

func describeLevel(startOfLevel:bool):
	if (TTS.enabled):
		##await get_tree().process_frame
		if(startOfLevel):
			TTS.readMap(playRegion,map,self,listOfBuildings,levelDescription)
		else:
			TTS.readMap(playRegion,map,self,listOfBuildings,"")
func describeSquare(pos:Vector2i):
	if(TTS.enabled):
		var string = TTS.readTile2(pos,map,self)
		TTS.addText(string,true)
func describeBuildings():
	TTS.addText("Buildings to place are:",false)
	for b in listOfBuildings:
		TTS.readBuilding(b);

##Prompts reading the current builidng under the cursor or 
##the building to be placed if the cursor is over an currently empty space
func inspect():
	var tile = map.get_cell_tile_data(0,location);
	if(playRegion.has(location)&& tile != null):
		var buildingName = allBuildings[tile.get_custom_data("BuildingID")].getName();
		var string = "A "+ buildingName + DescriptionsParser.getDescription(buildingName);
		TTS.addText(string,true);
	else:
		var string = currentBuilding.getName();
		string = "To place a "+ string;
		TTS.addText(string,true);

##Helper function to let other objects check if the current tilemap is moused over
func mouseOverMap() -> bool:
	if(location!=null&&playRegion.has(location)):
		return true;
	return false;

##Used to play a oneshote animation for when a placement fails
func cantPlaceAnimation(i:Vector2i):
	var hatesAnim = hatesAnimationSprite.instantiate();
	hatesAnim.position = map.map_to_local(i);
	add_child(hatesAnim);

##Adds all buildings to be placed and which are already on the map to the UI for displaing in the guide
func setupUI():
	for b in listOfBuildings:
		if(b is DoubleBuilding):
			var tempB = b.getBuilding();
			for t in tempB:
				if(!buildingsForGuide.has(t)):
					buildingsForGuide.append(t);
		else:
			if(!buildingsForGuide.has(b)):
				buildingsForGuide.append(b);
	for p in playRegion:
		var data = map.get_cell_tile_data(0,p);
		if(data!=null):
			var tempBuilding = allBuildings[data.get_custom_data("BuildingID")];
			if(!buildingsForGuide.has(tempBuilding)):
				buildingsForGuide.append(tempBuilding);
	ui.setBuildingList(listOfBuildings);
	ui.setBuildingMenu();
	
func _input(event):
	if(event.is_action_pressed("Read")):
		TTS.stop();
		describeLevel(false);
	if(event.is_action_pressed("Inspect")):
		inspect();
	if(event.is_action_pressed("Buildings")):
		describeBuildings()
	if(playing):
		if(event.is_action_pressed("Place")&&playRegion.has(location)):
			if(event is InputEventMouse):
				var tempLocation = map.get_local_mouse_position();
				tempLocation = map.local_to_map(tempLocation);
				if(playRegion.has(tempLocation)):
					checkPlace(location);
			else:
				if(event is InputEventKey or event is InputEventJoypadButton):
					checkPlace(location)
		if(event.is_action_pressed("undo")):
			undo();
