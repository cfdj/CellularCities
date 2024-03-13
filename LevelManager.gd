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
var negativeHint = Vector2i(2,0);
var positiveHint = Vector2i(4,6);
@export var buildAnimation:AnimatedSprite2D;

var playing = true;
static var mouse = true;

@export var ui:UIManager;
@export var allBuildings:Array[Building] ##An array of all buildings in ID order

@export var audio:AudioManager;
@export var levelDescription:String
func _ready():
	currentBuilding = listOfBuildings[current];
	
	
	playRegion = map.get_used_cells_by_id(2,0,playRegionMarker)
	for i in playRegion:
		map.erase_cell(2,i);
	ui.setBuildingList(listOfBuildings);
	hint();
	level = Loader.levels.find(get_parent().get_parent().scene_file_path);
	ui.setBuildingMenu();
	if(!mouse):
		location = playRegion[0];
	describeLevel();
	describeBuildings();
func _physics_process(delta):
	if playing:
		if mouse:
			var mousePos = get_viewport().get_mouse_position();
			location = map.to_local(mousePos);
			location = map.local_to_map(mousePos);
		elif !mouse:
			var vertical = Vector2i(0,0)
			if(Input.is_action_just_pressed("Up")or Input.is_action_just_pressed("Down")):
				vertical = Vector2i(Vector2i(0,1)*Input.get_axis("Up","Down"))
			var horizontal =  Vector2i(0,0)
			if(Input.is_action_just_pressed("Left")or Input.is_action_just_pressed("Right")):
				horizontal = Vector2i(Vector2i(1,0)*Input.get_axis("Left","Right"));
			location += horizontal
			if(!playRegion.has(location)):
				location -= horizontal;
			location += vertical
			if(!playRegion.has(location)):
				location -= vertical
		if location != previousLocation:
			map.erase_cell(3,previousLocation);
			if playRegion.has(location):
				if map.get_cell_tile_data(0,location) == null:
					map.set_cell(3,location,0,currentBuilding.spriteLocation);
				else:
					map.set_cell(3,location,0,Vector2i(0,0))
				describeSquare(location);
			previousLocation = location;
		if(Input.is_action_just_pressed("click")):
			checkPlace(location);
		if(Input.is_action_just_pressed("undo")):
			undo();

func checkPlace(location):
	var valid = true;
	if !playRegion.has(location):
		valid = false
	if(map.get_cell_tile_data(0,location) == null):
		var neighbours = map.get_surrounding_cells(location);
		for i in neighbours:
			var n = map.get_cell_tile_data(0,i);
			if(n != null):
				if currentBuilding.getHates(n.get_custom_data("BuildingID")):
					valid = false;
					audio.cantSound();
	else:
		valid = false;
	if(valid):
		place(location);
func place(location):
	var placing = currentBuilding;
	map.erase_cell(3,location);
	clearHint();
	##setting a temporary building
	map.set_cell(0,location,2,placing.spriteLocation);
	buildAnimation.visible = false;
	buildAnimation.stop();
	buildAnimation.frame=0;
	buildAnimation.position = map.map_to_local(location);
	buildAnimation.visible= true;
	buildAnimation.play();
	listOfPlaced.append(location);
	TTS.placeBuilding(placing,location)
	current+=1;
	ui.popBuildingList();
	if(current<listOfBuildings.size()):
		currentBuilding = listOfBuildings[current];
		
		TTS.addText("Next building is");
		TTS.readBuilding(currentBuilding);
		hint();
	else:
		finishLevel();
	await buildAnimation.animation_finished;
	map.set_cell(0,location,0,placing.spriteLocation);
	buildAnimation.visible = false;
func undo():
	if current >0:
		current -=1;
		currentBuilding = listOfBuildings[current];
		var clearLocation = listOfPlaced.pop_back();
		map.erase_cell(0,clearLocation);
		TTS.undoBuilding(currentBuilding,clearLocation)
		ui.pushBuildingList(currentBuilding);
		var mousePos = get_viewport().get_mouse_position();
		location = map.to_local(mousePos);
		location = map.local_to_map(mousePos);
		map.erase_cell(3,previousLocation);
		if playRegion.has(location):
			map.set_cell(3,location,0,currentBuilding.spriteLocation);
		clearHint();
		hint();
func finishLevel():
	TTS.stop();
	audio.levelDoneSound();
	ui.showNextlevelButton();
	playing = false;
	ui.updateScore(map,playRegion);
	for i in playRegion:
		if(map.get_cell_tile_data(0,i) ==null):
			var streetLocation =streetLocations[randi() % streetLocations.size()];
			map.set_cell(0,i,0,streetLocation)
			await get_tree().create_timer(0.2).timeout
	TTS.addText("Total score: " +str(ui.scoreDisplay.totalScore))
func hint():
	for i in playRegion:
		if(map.get_cell_tile_data(0,i)!= null):
			var id = map.get_cell_tile_data(0,i).get_custom_data("BuildingID")
			if currentBuilding.getHates(id):
				var neighbours = map.get_surrounding_cells(i);
				for n in neighbours:
					if(map.get_cell_tile_data(0,n)==null &&playRegion.has(n)):
						map.set_cell(2,n,0,negativeHint);
			elif currentBuilding.getlike(id):
				var neighbours = map.get_surrounding_cells(i);
				for n in neighbours:
					##Hates will override likes
					if(map.get_cell_tile_data(0,n)==null &&playRegion.has(n)&& map.get_cell_tile_data(2,n)==null):
						map.set_cell(2,n,0,positiveHint);
func clearHint():
	for i in playRegion:
		map.erase_cell(2,i);

func describeLevel():
	if (TTS.enabled):
		TTS.readMap(playRegion,map,self)
func describeSquare(pos:Vector2i):
	if(TTS.enabled):
		TTS.readtile(pos,map,self)
func describeBuildings():
	TTS.addText("Buildings to place are:")
	for b in listOfBuildings:
		TTS.readBuilding(b);
