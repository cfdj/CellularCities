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
	var texture = building.getTexture()
	add_icon_item(texture,false);
	move_item(item_count-1,0);
