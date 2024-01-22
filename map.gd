class_name Map extends TileMap

var currentStreets:Dictionary;
var currentFoundries:Dictionary;
var currentOffices:Dictionary;
var currentAmmenities:Dictionary;
var currentEmptyTiles:Dictionary;
var currentFlats:Dictionary;
# Called when the node enters the scene tree for the first time.
func _ready():
	Singletons.tilemap = self;

func turn():
	get_tree().call_group("Tiles", "calculateDesire")
	if(!currentEmptyTiles.keys().is_empty()):
		get_tree().call_group("Streets","update")
func addStreet(location:Vector2i,street:Street):
	currentEmptyTiles.erase(location);
	currentStreets[location] = street;
func removeStreet(location:Vector2i,street:Street):
	currentStreets.erase(location);
	set_cell(0,location,1,Vector2i(0,0),0);
func addFoundry(location:Vector2i,foundry:Foundry):
	currentEmptyTiles.erase(location);
	currentFoundries[location] = foundry;
func removeFoundry(location:Vector2i,foundry:Foundry):
	currentFoundries.erase(location);
	set_cell(0,location,1,Vector2i(0,0),0);
func addOffice(location:Vector2i,office:Office):
	currentEmptyTiles.erase(location);
	currentOffices[location] = office;
func removeOffice(location:Vector2i,office:Office):
	currentOffices.erase(location);
	set_cell(0,location,1,Vector2i(0,0),0);
func addFlat(location:Vector2i,flat:Flat):
	currentEmptyTiles.erase(location);
	currentFlats[location] = flat;
func removeFlat(location:Vector2i,flat:Flat):
	currentFlats.erase(location);
	set_cell(0,location,1,Vector2i(0,0),0);
func upgradeToFlat(location:Vector2i,tileID:int):
	currentStreets.erase(location);
	set_cell(0,location,1,Vector2i(0,0),tileID)
func addEmptyTile(location:Vector2i,tile:Tile):
	currentEmptyTiles[location] = tile;

func getHighestDesireEmpty() -> Vector2i:
	var newLocation:Vector2i;
	var highest = 0;
	for n in currentEmptyTiles.values():
		if(n.desire> highest):
			highest = n.desire;
			newLocation = n.location;
	currentEmptyTiles.erase(newLocation);
	return newLocation;
