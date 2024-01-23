class_name Ammenity extends Tile

@export var workers:int;
@export var leaveThreshold:int;
@export var alternativeFrames:Array[Vector2i];
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready();
	map.addAmmenity(location,self);
	add_to_group("Ammenity");
	$Sprite2D.frame_coords = alternativeFrames[randi() % alternativeFrames.size()]
func update():
	if(desire<=leaveThreshold):
		move(map.getHighestDesireEmpty());
func move(newLocation:Vector2i):
	map.set_cell(0,newLocation,1,Vector2i(0,0),tileID)
	map.removeAmmenity(location,self);
