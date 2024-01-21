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
func calculateDesire():
	var neighbours = map.get_surrounding_cells(location);
	desire = 0;
	for n in neighbours:
		if(!map.currentEmptyTiles.has(n)):
			if(map.currentFoundries.has(n)):
				desire+=foundryDraw;
			elif (map.currentOffices.has(n)):
				desire+=officeDraw;
			elif (map.currentAmmenities.has(n)):
				desire+=amenityDraw;
