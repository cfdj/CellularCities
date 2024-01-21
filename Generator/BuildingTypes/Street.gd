class_name Street extends Tile

@export var workers:int;
@export var leaveThreshold:int;
@export var upgradeThreshold:int;
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready();
	map.addStreet(location,self);
	add_to_group("Streets");

func update():
	if(desire<=leaveThreshold):
		move(map.getHighestDesireEmpty());
func move(newLocation:Vector2i):
	map.set_cell(0,newLocation,1,Vector2i(0,0),tileID)
	map.removeStreet(location,self);
