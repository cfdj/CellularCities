class_name BuildingList extends ItemList

var tileWidth = 62;
var tileHeight = 48;

func setItemList(buildings:Array[Building]):
	var tempBuildings = buildings.duplicate()
	tempBuildings.reverse();
	for i in tempBuildings:
		pushItemList(i);

func popItemList():
	remove_item(0);

func pushItemList(building:Building):
	##Add the current Building back to ItemList
	##var texture = AtlasTexture(building.sprite.texture,true,Rect2(0,0,0,0),Rect2(tileWidth*building.spriteLocation.x,tileHeight*building.spriteLocation.y,tileWidth,tileHeight))
	var image = building.texture.get_image();
	var texture = ImageTexture.create_from_image(image.get_region(Rect2(tileWidth*building.spriteLocation.x,tileHeight*building.spriteLocation.y,tileWidth,tileHeight)))
	add_icon_item(texture,false);
	move_item(item_count-1,0);
