class_name DoubleBuilding extends Building
###Extends buildings to have two adjacent buildings placed at once
###This supports not only checking placement but also UI display and speech
##Player directly places the lowerbuilding, with the upper building placed in relation to it
@export var upperBuilding:Building
@export var lowerBuilding:Building
var upperLocationVector:Vector2i = Vector2i(0,-1);

func checkPlaceable(map:TileMap,location:Vector2i,playRegion:Array[Vector2i]) -> squareValidity:
	var currentValidity = squareValidity.NEUTRAL;
	var lowerValidity = lowerBuilding.checkPlaceable(map,location,playRegion);
	var upperValidity = upperBuilding.checkPlaceable(map,location+upperLocationVector,playRegion);
	##If either hates, can't be placed
	if(lowerValidity == squareValidity.HATES or upperValidity == squareValidity.HATES):
		currentValidity = squareValidity.HATES;
	##if either likes, likes
	elif (lowerValidity == squareValidity.LIKES or upperValidity == squareValidity.LIKES):
		currentValidity = squareValidity.LIKES;
	return currentValidity;

##Used for checking individual squares to play animations
##Requires constructing an internal list of which tiles it interacts with, as it might not always be neighbours
##Theres some UX decisions in how this should communicate with players
##At the moment it checks which the other Tile is relevant to
func checkIndividual(map:TileMap,location:Vector2i,otherTile:Vector2i,playRegion:Array[Vector2i])->squareValidity:
	var validity = squareValidity.NEUTRAL;
	var neighbours = lowerBuilding.relevantTiles(map,location); 
	var upperneighbours = upperBuilding.relevantTiles(map,location+upperLocationVector);
	if(!(playRegion.has(location)&& playRegion.has(location+upperLocationVector))):
		validity = squareValidity.HATES;
	if(neighbours.has(otherTile)):
		validity = lowerBuilding.checkIndividual(map,location,otherTile,playRegion)
	if upperneighbours.has(otherTile) && validity!=squareValidity.HATES:
		validity = upperBuilding.checkIndividual(map,location+upperLocationVector,otherTile,playRegion);
	return validity;

func place(map:TileMap,location:Vector2i):
	upperBuilding.place(map,location+upperLocationVector);
	await upperBuilding.placingComplete;
	lowerBuilding.place(map,location);


func undo(map:TileMap,location:Vector2i):
	lowerBuilding.undo(map,location);
	upperBuilding.undo(map,location+upperLocationVector);

func cursor(map:TileMap,location:Vector2i):
	lowerBuilding.cursor(map,location);
	upperBuilding.cursor(map,location+upperLocationVector);
func clearCursor(map:TileMap,location:Vector2i):
	lowerBuilding.clearCursor(map,location);
	upperBuilding.clearCursor(map,location+upperLocationVector);

func relevantTiles(map:TileMap, location:Vector2i)->Array[Vector2i]:
	var relevant:Array[Vector2i]
	relevant.append_array(lowerBuilding.relevantTiles(map,location));
	relevant.append_array(upperBuilding.relevantTiles(map,location+upperLocationVector));
	return relevant;

func getTexture() -> ImageTexture:
	var frontBuilding:ImageTexture = lowerBuilding.getTexture();
	var backBuilding:ImageTexture = upperBuilding.getTexture();
	var image:Image = Image.create(62,48,false,frontBuilding.get_format())
	image.blit_rect(backBuilding.get_image(),Rect2i(0,0,tileWidth,tileHeight),Vector2i(10,-6))
	image.blit_rect_mask(frontBuilding.get_image(),frontBuilding.get_image(),Rect2i(0,0,tileWidth,tileHeight),Vector2i(-10,6));
	return ImageTexture.create_from_image(image)

func getName()-> String:
	var string:String = "Double Building ";
	string += lowerBuilding.getName() + " with a " + upperBuilding.getName() + " above it";
	return string;

func getBuilding() -> Array[Building]:
	var building:Array[Building] = [lowerBuilding,upperBuilding];
	return building;
