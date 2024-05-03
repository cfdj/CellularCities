extends Node

var savePath = "user://settings.cfg"
var settingPath = "Settings"
var config;

var canSave = false;
func _ready():
	if(!OS.has_feature("web")):
		print("Can Save")
		canSave = true
		config = ConfigFile.new()
		config.load(savePath)
func save(property,Value):
	if(canSave):
		# Store some values.
		config.set_value(settingPath, property, Value)

		# Save it to a file (overwrite if already exists).
		config.save(savePath)

func getSettingValue(property):
	var value = null;
	if(canSave):
		value = config.get_value(settingPath, property)
	return value
