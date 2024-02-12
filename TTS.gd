class_name TTSManager extends Node

var enabled:bool = true;
var voice:int = 0;
var volume:int = 50;
var speed:int = 1.0;

var yNames = ["1","2","3","4","5","6","7","8"]
var xNames = ["A","B","C","D","E","F","G","H"]
var topLeft:Vector2i
func _ready():
	DisplayServer.tts_stop();
func addText(text:String):
	var v = DisplayServer.tts_get_voices_for_language("en")[voice]
	DisplayServer.tts_speak(text,v,volume,1.0,speed)

##Currently reads empty spaces and neighbours
##Levels should probably have an introduction
func readMap(playRegion:Array[Vector2i],map:TileMap,level:LevelManager):
	var bottomRight:Vector2i
	var xMin = 9999;
	var yMin = 9999;
	var xMax = 0;
	var yMax = 0;
	for v in playRegion:
		if(v.x<xMin or v.y<yMin):
			xMin = v.x;
			yMin = v.y;
			topLeft = v;
		if (v.x>xMax or v.y>yMax):
			xMax = v.x;
			yMax = v.y;
			bottomRight = v;
	var width = xMax-xMin;
	var height = yMax-yMin;
	for y in height+1:
		for x in width+1:
			var tempVector = topLeft+Vector2i(x,y);
			if(playRegion.has(tempVector)):
				readtile(tempVector,map,level);
				

func readtile(pos:Vector2i,map:TileMap,level:LevelManager):
	var tile = map.get_cell_tile_data(0,pos);
	var string = xNames[pos.x-topLeft.x] + "," + yNames[pos.y-topLeft.y]
	if(tile == null):
		string += " is empty"
		addText(string);
	else:
		string += " is a " +level.allBuildings[tile.get_custom_data("BuildingID")].name
		addText(string);

func readNeighbours(pos:Vector2i,map:TileMap,level:LevelManager):
	var neighbours = map.get_surrounding_cells(pos);
	for n in neighbours:
		if(level.playRegion.has(n)):
			readtile(n,map,level);

func readBuilding(building:Building):
	var string = str(building.name)
	addText(string);
func placeBuilding(building:Building, pos:Vector2i):
	var locationString:String = xNames[pos.x-topLeft.x] + "," + yNames[pos.y-topLeft.y]
	var string:String = building.name + " placed in " + locationString
	addText(string)
func undoBuilding(building:Building, pos:Vector2i):
	var locationString:String = xNames[pos.x-topLeft.x] + "," + yNames[pos.y-topLeft.y]
	var string:String = building.name + " removed from " +locationString
	addText(string)
func stop():
	DisplayServer.tts_stop();

func guide(buildings:Array[Building],level:LevelManager):
	var alreadyRead:Array[Building] = [];
	for b in buildings:
		if(!alreadyRead.has(b)):
			addText(b.name + " likes")
			for t in level.allBuildings.size():
				print(t)
				if(b.getlike(t)):
					readBuilding(level.allBuildings[t])
			addText("hates")
			for t in b.hatesArray[b.id].size():
				if(b.getHates(t)):
					readBuilding(level.allBuildings[t])
		alreadyRead.append(b)
