extends Node

@export var level:int;
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
var playing = true;

@export var nextlevelButton:Button;
@export var levels:Array[String];
func _ready():
	currentBuilding = listOfBuildings[current];
	
	
	playRegion = map.get_used_cells_by_id(2,0,playRegionMarker)
	for i in playRegion:
		map.erase_cell(2,i);
func _physics_process(delta):
	if playing:
		var mousePos = get_viewport().get_mouse_position();
		location = map.to_local(mousePos);
		location = map.local_to_map(mousePos);
		if location != previousLocation:
			map.erase_cell(2,previousLocation);
			if playRegion.has(location):
				map.set_cell(2,location,0,currentBuilding.spriteLocation);
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
	else:
		valid = false;
	if(valid):
		place(location);
func place(location):
	map.set_cell(0,location,0,currentBuilding.spriteLocation);
	map.erase_cell(2,location);
	listOfPlaced.append(location);
	current+=1;
	if(current<listOfBuildings.size()):
		currentBuilding = listOfBuildings[current];
	else:
		finishLevel();

func undo():
	if current >0:
		current -=1;
		currentBuilding = listOfBuildings[current];
		var clearLocation = listOfPlaced.pop_back();
		map.erase_cell(0,clearLocation);
func finishLevel():
	nextlevelButton.visible = true;
	playing = false;
	for i in playRegion:
		if(map.get_cell_tile_data(0,i) ==null):
			var streetLocation =streetLocations[randi() % streetLocations.size()];
			map.set_cell(0,i,0,streetLocation)
		await get_tree().create_timer(0.2).timeout

func nextLevel():
	if(level+1 <levels.size()):
		get_tree().change_scene_to_file(levels[level+1]);
	
