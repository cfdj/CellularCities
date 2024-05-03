extends Node

var savePath = "user://settings.cfg"
var settingPath = "Settings"
var config;
func _ready():
	config = ConfigFile.new()

func save(property,Value):
	# Store some values.
	config.set_value(settingPath, property, Value)

	# Save it to a file (overwrite if already exists).
	config.save(savePath)

func getSettingValue(property):
	var value = config.get_value(settingPath, property)
	
	return value
