class_name Generator extends Node

@export var tileMap:TileMap
var tileLocations:Dictionary;
# Called when the node enters the scene tree for the first time.
func _ready():
	MapGenerator.tileMap = tileMap;
	

func generate():
	get_tree().call_group("Tiles","generate")
	var checking = tileLocations.keys()
	for i in tileMap.get_layers_count()-1:
		var tiles = [];
		for x in checking:
			if(tileLocations[x] == i):
				tiles.append(x);
		tileMap.set_cells_terrain_connect(i,tiles,0,0)
	

func placeTile(layer:int,location:Vector2i,tile:Vector2i):
	tileMap.set_cell(layer,location,0,tile);
	tileLocations[location] = layer
	##tileMap.set_cells_terrain_connect(layer,tileLocations.keys(),0,0)
	tileMap.erase_cell(6,location);
