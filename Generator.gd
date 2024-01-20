class_name Generator extends Node

@export var tileMap:TileMap
var tileLocations:Dictionary;
# Called when the node enters the scene tree for the first time.
func _ready():
	MapGenerator.tileMap = tileMap;
	

func generate():
	get_tree().call_group("Tiles","generate")
	var checking = tileLocations.keys()
	var terrains = tileMap.tile_set.get_terrains_count(0);
	for i in terrains:
		var tiles = [];
		for x in checking:
			if(tileLocations[x] == i):
				tiles.append(x);
		tileMap.set_cells_terrain_connect(1,tiles,0,i,true)
	

func placeTile(layer:int,location:Vector2i,tile:Vector2i,terrainLevel:int):
	##tileMap.set_cell(layer,location,0,tile);
	tileLocations[location] = terrainLevel
	tileMap.erase_cell(2,location);
