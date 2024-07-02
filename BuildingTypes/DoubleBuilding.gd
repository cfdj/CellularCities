extends Building
###Extends buildings to have two adjacent buildings placed at once
###This supports not only checking placement but also UI display and speech
##Player directly places the lowerbuilding, with the upper building placed in relation to it
@export var upperBuilding:Building
@export var lowerBuilding:Building
var upperLocationVector:Vector2i = Vector2i(0,-1);

func checkPlaceable(map:TileMap,location:Vector2i) -> squareValidity:
	var currentValidity = squareValidity.NEUTRAL;
	var lowerValidity = lowerBuilding.checkPlaceable(map,location);
	var upperValidity = upperBuilding.checkPlaceable(map,location+upperLocationVector);
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
func checkIndividual(map:TileMap,location:Vector2i,otherTile:Vector2i)->squareValidity:
	var validity = squareValidity.NEUTRAL;
	var neighbours = lowerBuilding.relevantTiles(map,location); 
	var upperneighbours = upperBuilding.relevantTiles(map,location+upperLocationVector);
	if(neighbours.has(otherTile)):
		var n = map.get_cell_tile_data(0,otherTile);
		if(n != null):
			if lowerBuilding.getHates(n.get_custom_data("BuildingID")):
				validity = squareValidity.HATES;
		if(validity != squareValidity.HATES):
			if(n != null):
				if lowerBuilding.getlike(n.get_custom_data("BuildingID")):
					validity = squareValidity.LIKES;
	elif upperneighbours.has(otherTile):
		var n = map.get_cell_tile_data(0,otherTile);
		if(n != null):
			if upperBuilding.getHates(n.get_custom_data("BuildingID")):
				validity = squareValidity.HATES;
		if(validity != squareValidity.HATES):
			if(n != null):
				if upperBuilding.getlike(n.get_custom_data("BuildingID")):
					validity = squareValidity.LIKES;
	return validity;
