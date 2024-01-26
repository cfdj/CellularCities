class_name Tile extends Node2D

var location:Vector2i;
var desire:int;
var map:TileMap;
@export var tileID:int;
@export var foundryDraw:int;
@export var officeDraw:int;
@export var amenityDraw:int;
# Called when the node enters the scene tree for the first time.
func _ready():
	map = Singletons.tilemap;
	location = map.local_to_map(position);
	add_to_group("Tiles")
	map.currentEmptyTiles[location] = self;
##Calculates desire based on neighbours, and neighbours neighbours (not including itself, double counting diagonals)
func calculateDesire():
	var immediateNeighbours = map.get_surrounding_cells(location);
	var neighbours = immediateNeighbours.duplicate();
	for n in immediateNeighbours:
		neighbours.append_array(map.get_surrounding_cells(n));
	neighbours.filter(removeSelf);
	desire = 1;
	for n in neighbours:
		if(!map.currentEmptyTiles.has(n)):
			if(map.currentFoundries.has(n)):
				desire+=foundryDraw;
			elif (map.currentOffices.has(n)):
				desire+=officeDraw;
			elif (map.currentAmmenities.has(n)):
				desire+=amenityDraw;
func removeSelf(l):
	return l != location;
