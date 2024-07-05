class_name Building extends Node
###Base class for handling placeable buildings
###Handles checking the validity of placement (this was previously handled by the level manager
###This functionality was moved so more complex buildings could handle their own checking
@export var spriteLocation:Vector2i;
@export var id:int;
@export var texture:Texture2D
@export var buildAnimation:AnimatedSprite2D
var tileWidth = 62;
var tileHeight = 48;
##row = id, column = likes or dislikes (symmetric)
static var hatesArray= [
	[false,false,false,false,false,false,false,false,false,false,false,false,false], #Street
	[false,false,true,false,false,false,true,false,false,false,false,true,false], #Flat
	[false,true,false,false,true,false,false,false,false,false,false,false,false], #Foundry
	[false,false,false,true,false,false,false,false,false,false,false,true,false], #Cinema
	[false,false,true,false,false,false,false,false,false,false,false,true,false], #University
	[false,false,false,false,false,false,false,false,false,false,false,false,false], #Station
	[false,true,false,false,false,false,false,false,false,false,false,false,false], #Rails
	[false,false,false,false,false,false,false,false,false,false,false,false,false], #Forest
	[false,false,false,false,false,false,false,false,false,false,true,false,false], #Gas works
	[false,false,false,false,false,false,false,false,false,false,false,false,false], #Hill
	[false,false,false,false,false,false,false,false,true,false,false,true,false], #Office
	[false,true,false,true,true,false,false,false,false,false,true,false,false], #Mine
	[false,false,false,false,false,false,false,false,false,false,false,false,false]] #River
static var likesArray = [
	[false,false,false,false,false,false,false,false,false,false,false,false,true], #Street
	[false,false,false,true,false,true,false,true,false,true,true,false,true], #Flat
	[false,false,false,false,false,false,false,false,false,false,false,false,true], #Foundry
	[false,true,false,false,true,false,false,false,false,false,true,false,true], #Cinema
	[false,false,false,true,false,true,false,false,false,true,false,false,true], #University
	[false,true,false,false,true,false,false,false,false,false,false,false,true], #Station
	[false,false,false,false,false,false,false,false,false,false,false,false,true], #Rails
	[false,true,false,false,false,false,false,false,false,false,false,false,true], #Forest
	[false,false,false,false,false,false,false,false,false,false,false,false,true], #Gas works
	[false,true,false,false,true,false,false,false,false,false,false,true,true], #Hill
	[false,true,false,true,false,false,false,false,false,false,false,false,true],#Office
	[false,false,false,false,false,false,false,false,false,true,false,false,true],#Mine
	[true,true,true,true,true,true,true,true,true,true,true,true,false]] #River

func getlike(checkingId:int) -> bool:
	var likes = likesArray[id][checkingId];
	return likes;

func getHates(checkId:int) -> bool:
	var hates = hatesArray[id][checkId];
	return hates;

##Refactoring to allow more complex buildings
func checkPlaceable(map:TileMap,location:Vector2i,playRegion:Array[Vector2i]) -> squareValidity:
	var currentValidity = squareValidity.NEUTRAL;
	var neighbours = relevantTiles(map,location);
	##Check hates, then if it can be placed, check likes
	if(!playRegion.has(location) or map.get_cell_tile_data(0,location) != null):
		currentValidity = squareValidity.HATES;
	for i in neighbours:
		var n = map.get_cell_tile_data(0,i);
		if(n != null):
			if getHates(n.get_custom_data("BuildingID")):
				currentValidity = squareValidity.HATES;
	if(currentValidity != squareValidity.HATES):
		for i in neighbours:
			var n = map.get_cell_tile_data(0,i);
			if(n != null):
				if getlike(n.get_custom_data("BuildingID")):
					currentValidity = squareValidity.LIKES;
	return currentValidity;

##Used for checking individual squares to play animations
##Requires constructing an internal list of which tiles it interacts with, as it might not always be neighbours
func checkIndividual(map:TileMap,location:Vector2i,otherTile:Vector2i,playRegion:Array[Vector2i])->squareValidity:
	var validity = squareValidity.NEUTRAL;
	var neighbours = relevantTiles(map,location);
	if(!playRegion.has(location)):
		validity = squareValidity.HATES;
	elif(neighbours.has(otherTile)):
		var n = map.get_cell_tile_data(0,otherTile);
		if(n != null):
			if getHates(n.get_custom_data("BuildingID")):
				validity = squareValidity.HATES;
		if(validity != squareValidity.HATES):
			if(n != null):
				if getlike(n.get_custom_data("BuildingID")):
					validity = squareValidity.LIKES;
	return validity;
##Handles placing buildings
##First sets an invisible building before the animation plays to allow hinting to occur
func place(map:TileMap,location:Vector2i):
	map.set_cell(0,location,2,spriteLocation);
	buildAnimation.visible = false;
	buildAnimation.stop();
	buildAnimation.frame=0;
	buildAnimation.position = map.map_to_local(location);
	buildAnimation.visible= true;
	buildAnimation.play();
	await buildAnimation.animation_finished;
	buildAnimation.visible = false;
	map.set_cell(0,location,0,spriteLocation);

func undo(map:TileMap,location:Vector2i):
	map.erase_cell(0,location)

func cursor(map:TileMap,location:Vector2i):
	if map.get_cell_tile_data(0,location) == null:
		map.set_cell(3,location,0,spriteLocation);
	else:
		map.set_cell(3,location,0,Vector2i(0,0))
func clearCursor(map:TileMap,location:Vector2i):
	map.erase_cell(3,location);

func relevantTiles(map:TileMap, location:Vector2i)->Array[Vector2i]:
	var relevant:Array[Vector2i]
	relevant = map.get_surrounding_cells(location);
	return relevant;
enum squareValidity{NEUTRAL,HATES,LIKES}

func getTexture() -> ImageTexture:
	var image = texture.get_image();
	return ImageTexture.create_from_image(image.get_region(Rect2i(tileWidth*spriteLocation.x,tileHeight*spriteLocation.y,tileWidth,tileHeight)))

func getName()-> String:
	return name;

func getBuilding() -> Array[Building]:
	var building:Array[Building] = [self];
	return building;
