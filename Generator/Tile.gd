class_name Tile extends Node2D

@export var tile:Vector2i;
@export var layer:int;
var location:Vector2i;
# Called when the node enters the scene tree for the first time.
func _ready():
	location = MapGenerator.tileMap.local_to_map(position);
	add_to_group("Tiles");
func generate():
	MapGenerator.placeTile(layer,location,tile)
	queue_free();
