extends Node
###Handles File reading and loading
##Additionally handles loading in rebound keybindings
##Keybindings are save in the KeyBindings Resource
##Format:
##Dictionary 1: Action - Changed
##Dictionary 2: Event - Type (0 EventKey,1 JoypadButton,2 JoypadAxis,3 MouseButton)
##Dictionary 3: Action Events[]
var savePath = "user://settings.cfg"
var settingPath = "Settings"
var config;

@onready var keybindsResource : KeyBindings = preload("res://SaveSystem/KeyBinds.tres");

var canSave = false;
func _ready():
	if(!OS.has_feature("web")):
		print("Can Save")
		canSave = true
		config = ConfigFile.new()
		config.load(savePath)

		setupKeyBindings()
		#keyBindsReset()
		#saveKeyBinds()
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

func setupKeyBindings():
	var bindings = InputMap.get_actions()
	for b in bindings:
		var changed = keybindsResource.getChanged(b)
		if(changed):
			print(b + " has changed")
			InputMap.action_erase_events(b);
			var events = keybindsResource.getBindings(b)
			for e in events:
				InputMap.action_add_event(b,e);
func keyBindsReset():
	for a in InputMap.get_actions():
		keybindsResource.markUnchanged(a);

func markRebind(action:StringName):
	print(action + " marked as rebound")
	keybindsResource.markChanged(action);

func saveKeyBinds():
	if(canSave):
		print("Saving keybindings")
		var actions = InputMap.get_actions()
		for a in actions:
			if(keybindsResource.getChanged(a)):
				keybindsResource.saveRebind(a);
			
		ResourceSaver.save(keybindsResource)
