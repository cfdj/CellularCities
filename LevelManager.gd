extends Node

@export var map:TileMap;
@export var listOfBuildings:Array[Building];
var currentBuilding:Building;
var previousLocation:Vector2i;
var location:Vector2i;

var current:int = 0;
var listOfPlaced:Array[Vector2i];

func _ready():
	currentBuilding = listOfBuildings[current];
	
func _physics_process(delta):
	var mousePos = get_viewport().get_mouse_position();
	location = map.to_local(mousePos);
	location = map.local_to_map(mousePos);
	if location != previousLocation:
		map.erase_cell(2,previousLocation);
		map.set_cell(2,location,0,currentBuilding.spriteLocation);
		previousLocation = location;
	if(Input.is_action_just_pressed("click")):
		checkPlace(location);
	if(Input.is_action_just_pressed("undo")):
		undo();

func checkPlace(location):
	var valid = true;
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
	current+=1;
	listOfPlaced.append(location);
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
	pass;
