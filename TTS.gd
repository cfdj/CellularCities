class_name TTSManager extends Node

var enabled:bool = true;
var voice:int = 0;
var vString = null;
var volume:int = 50;
var speed:float = 1;

var yNames = ["1","2","3","4","5","6","7","8"]
var xNames = ["A","B","C","D","E","F","G","H"]
var topLeft:Vector2i
var id = 0;
func _ready():
	vString = DisplayServer.tts_get_voices_for_language("en")[0]
	##DisplayServer.tts_stop();
func addText(text:String,interrupt:bool):
	if(enabled):
		id+=1;
		#if(interrupt):
		#	stop();
		if(vString == null):
			vString = DisplayServer.tts_get_voices_for_language("en")[voice]
		DisplayServer.tts_speak(text,vString,volume,1.0,speed,id,interrupt)
		print(text)

##Currently reads empty spaces and neighbours, followed by buildings to place
##Levels should probably have an introduction
func readMap(playRegion:Array[Vector2i],map:TileMap,level:LevelManager,buildings:Array[Building],description:String):
	var bottomRight:Vector2i
	var xMin = 9999;
	var yMin = 9999;
	var xMax = 0;
	var yMax = 0;
	if(description.length()>0):
		description += " "
	var speechString =description+ "Describing City: "
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
			##Old method
			#if(playRegion.has(tempVector)):
				#readtile(tempVector,map,level);
				#
			##Alternative Method, reads much faster
			if(playRegion.has(tempVector)):
				speechString += readTile2(tempVector,map,level) + " "
	speechString += " Buildings to place are:"
	for b in buildings:
		var string = " "+ b.getName()+","
		speechString+=string;
	addText(speechString,false)

func readtile(pos:Vector2i,map:TileMap,level:LevelManager):
	var tile = map.get_cell_tile_data(0,pos);
	var string = xNames[pos.x-topLeft.x] + "," + yNames[pos.y-topLeft.y]
	if(tile == null):
		string += " is empty"
		addText(string,false);
	else:
		string += " is a " +level.allBuildings[tile.get_custom_data("BuildingID")].getName();
		addText(string,false);

##Used for testing an alternative level reading method
func readTile2(pos:Vector2i,map:TileMap,level:LevelManager):
	var tile = map.get_cell_tile_data(0,pos);
	var string = xNames[pos.x-topLeft.x] + "," + yNames[pos.y-topLeft.y]
	if(tile == null):
		string += " is empty"
		return string;
	else:
		string += " is a " +level.allBuildings[tile.get_custom_data("BuildingID")].getName();
	return string;

func readNeighbours(pos:Vector2i,map:TileMap,level:LevelManager):
	var neighbours = map.get_surrounding_cells(pos);
	for n in neighbours:
		if(level.playRegion.has(n)):
			readtile(n,map,level);

func readBuilding(building:Building):
	var string = building.getName();
	addText(string,false);
##Needs updating to support multiple buildings
func placeBuilding(building:Building, pos:Vector2i):
	var xName = pos.x-topLeft.x
	var yName = pos.y-topLeft.y
	if(xName <xNames.size() && yName <yNames.size()):
		var locationString:String = xNames[pos.x-topLeft.x] + "," + yNames[pos.y-topLeft.y]
		var string:String = building.getName() + " placed in " + locationString
		addText(string,true)
func undoBuilding(building:Building, pos:Vector2i):
	var xName = pos.x-topLeft.x
	var yName = pos.y-topLeft.y
	if(xName <xNames.size() && yName <yNames.size()):
		var locationString:String = xNames[pos.x-topLeft.x] + "," + yNames[pos.y-topLeft.y]
		var string:String = building.getName() + " removed from " +locationString
		addText(string,true)
func inspectBuilding(building:Building):
	var string = building.name;
	string+=" "+ DescriptionsParser.getDescription(string);
	addText(string,true)
func stop():
	print("Stopping")
	DisplayServer.tts_stop();

func guide(buildings:Array[Building],level:LevelManager):
	var alreadyRead:Array[Building] = [];
	for b in buildings:
		if(!alreadyRead.has(b)):
			addText(b.name + " likes",false)
			for t in level.allBuildings.size():
				if(b.getlike(t)&&buildings.has(level.allBuildings[t])):
					readBuilding(level.allBuildings[t])
			addText("hates",false)
			for t in b.hatesArray[b.id].size():
				if(b.getHates(t)&&buildings.has(level.allBuildings[t])):
					readBuilding(level.allBuildings[t])
		alreadyRead.append(b)

func enabledGet():
	var value = Saver.getSettingValue("TTSEnabled")
	if(value == null):
		enabledSet(enabled)
	else:
		enabled = value
	return enabled;
func enabledSet(value):
	Saver.save("TTSEnabled",value)
	enabled = value
func voiceGet():
	var value = Saver.getSettingValue("TTSvString")
	if(value == null):
		voiceSet(vString)
	else:
		vString = value
	return vString;
func voiceSet(value):
	Saver.save("TTSvString",value)
	vString = value

func volumeGet():
	var value = Saver.getSettingValue("TTSVolume")
	if(value == null):
		volumeSet(volume)
	else:
		volume = value
	return volume;
func volumeSet(value):
	Saver.save("TTSVolume",value)
	volume = value

func speedGet():
	var value = Saver.getSettingValue("TTSSpeed")
	if(value == null):
		speedSet(speed)
	else:
		speed = value
	return speed;
func speedSet(value):
	Saver.save("TTSSpeed",value)
	speed = value
