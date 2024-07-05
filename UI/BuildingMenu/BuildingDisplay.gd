class_name BuildingDisplay extends HBoxContainer

@export var buildingIcon:TextureRect;
@export var likesIcons:Array[TextureRect];
@export var hatesIcons:Array[TextureRect];
var tileWidth = 62;
var tileHeight = 48;
	
func setBuilding(building:Building,allBuildings:Array[Building],buildingsInLevel:Array[Building]):
	print(building)
	for l in likesIcons:
		l.visible = false;
	for h in hatesIcons:
		h.visible = false;
	buildingIcon.texture = building.getTexture();
	var likes = Building.likesArray[building.id];
	var numLikes = 0;
	for like in likes.size():
		if likes[like]:
			var tempBuilding = allBuildings[like];
			if(buildingsInLevel.has(tempBuilding)):
				createIcon(tempBuilding,likesIcons[numLikes]);
				numLikes+=1
	var hates = Building.hatesArray[building.id];
	var numHates = 0;
	for hate in hates.size():
		if hates[hate]:
			var tempBuilding = allBuildings[hate];
			if(buildingsInLevel.has(tempBuilding)):
				createIcon(tempBuilding,hatesIcons[numHates]);
				numHates +=1;
func createIcon(building:Building,icon:TextureRect):
	var image = building.getTexture();
	icon.texture = image
	icon.visible = true;
