class_name BuildingDisplay extends HBoxContainer

@export var buildingIcon:TextureRect;
@export var likesIcons:Array[TextureRect];
@export var hatesIcons:Array[TextureRect];
var tileWidth = 62;
var tileHeight = 48;
var displayingBuildings:Array[Building];
	
func setBuilding(building:Building,allBuildings:Array[Building]):
	for l in likesIcons:
		l.visible = false;
	for h in hatesIcons:
		h.visible = false;
	var image = building.texture.get_image();
	buildingIcon.texture = ImageTexture.create_from_image(image.get_region(Rect2(tileWidth*building.spriteLocation.x,tileHeight*building.spriteLocation.y,tileWidth,tileHeight)))
	var likes = Building.likesArray[building.id];
	var numLikes = 0;
	for like in likes.size():
		if likes[like]:
			var tempBuilding = allBuildings[like];
			numLikes+=1
			createIcon(tempBuilding,likesIcons[numLikes]);
	var hates = Building.hatesArray[building.id];
	var numHates = 0;
	for hate in hates.size():
		if hates[hate]:
			var tempBuilding = allBuildings[hate];
			numHates +=1;
			createIcon(tempBuilding,hatesIcons[numHates]);
func createIcon(building:Building,icon:TextureRect):
	var image = building.texture.get_image();
	icon.texture = ImageTexture.create_from_image(image.get_region(Rect2(tileWidth*building.spriteLocation.x,tileHeight*building.spriteLocation.y,tileWidth,tileHeight)))
	icon.visible = true;
