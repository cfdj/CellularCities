class_name Office extends Tile

@export var currentEmployment:int;
@export var maximumEmployment:int;
var inRange:Dictionary;
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready();
	map.addOffice(location,self);
	add_to_group("Offices");

func move(newLocation:Vector2i):
	map.set_cell(0,newLocation,1,Vector2i(0,0),tileID)
	map.removeOffice(location,self);
