extends Node
##This handes reading building descriptions from files, and when requested giving them to TTS

##Internal file path to the Descriptions JSON
@export var descriptionPath:String;

var descriptions;
func _ready():
	var content = read(descriptionPath);
	if(content!= "0"):
		var json = JSON.new()
		var error = json.parse(content)
		if(error == OK):
			var data:Dictionary = json.data
			descriptions = data["descriptions"]
		else:
			print("Error! Data incorrectly formatted")
	else:
		print("Error! Invalid Path")
##Opens the description file after checking the file exists
func read(path:String):
	if(FileAccess.file_exists(path)):
		var file = FileAccess.open(descriptionPath, FileAccess.READ)
		var content = file.get_as_text()
		file.close(); ##Doing a bit of cleanup
		return content
	return "0";

func getDescription(buildingName:String):
	if(descriptions.has(buildingName)):
		return descriptions[buildingName];
	return ""
