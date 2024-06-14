class_name KeyMenu extends VBoxContainer
#Keybindings menu
#Handles selecting which type of controls the player can select to modify

enum inputMethod {keyboard,controller}
var selectedMethod:inputMethod = inputMethod.keyboard;

@export var Buttons:Array[KeyButton];
var actions:Array[StringName];

@export var inputTypeSelect:OptionButton
@export var settingsButton:Button;
@export var ControllerSensitivity:SensitivitySlider

@export var includedButtons:Array[StringName]
@export var advancedButtons:Array[StringName]
@export var scrollContainer:ScrollContainer

var advancedBindings = false;
func _ready():
	actions = InputMap.get_actions();
	identifyController();
	setKeyBoardButtons();
	move_child(settingsButton,get_child_count())
	setFocusOrder()
	inputTypeSelect.add_item("Keyboard bindings")
	inputTypeSelect.add_item("Controller bindings")
	
	
func setKeyBoardButtons():
	for i in Buttons: ##Clearing the array of any already placed buttons
		remove_child(i)
		i.queue_free()
	Buttons.clear();
	for i in includedButtons:
		for event in InputMap.action_get_events(i):
			if(event is InputEventKey or event is InputEventMouseButton):
				var newButton = KeyButton.new();
				newButton.setAction(i,event);
				Buttons.append(newButton);
				add_child(newButton)
				newButton.setupSignals()
	if(advancedBindings):
		for i in advancedButtons:
			for event in InputMap.action_get_events(i):
				if(event is InputEventKey or event is InputEventMouseButton):
					var newButton = KeyButton.new();
					newButton.setAction(i,event);
					Buttons.append(newButton);
					add_child(newButton)
					newButton.setupSignals()

func setControllerButtons():
	for i in Buttons: ##Clearing the array of any already placed buttons
		remove_child(i)
		i.queue_free()
	Buttons.clear();
	for i in includedButtons:
		for event in InputMap.action_get_events(i):
			if(event is InputEventJoypadButton):
				var newButton = KeyButton.new();
				newButton.setAction(i,event);
				Buttons.append(newButton);
				add_child(newButton);
				newButton.setupSignals()
			if(event is InputEventJoypadMotion):
				var newButton = KeyButton.new() 
				newButton.setAction(i,event);
				Buttons.append(newButton);
				add_child(newButton);
				newButton.setupSignals()
	if(advancedBindings):
		for i in advancedButtons:
				for event in InputMap.action_get_events(i):
					if(event is InputEventJoypadButton):
						var newButton = KeyButton.new();
						newButton.setAction(i,event);
						Buttons.append(newButton);
						add_child(newButton);
						newButton.setupSignals()
					if(event is InputEventJoypadMotion):
						var newButton = KeyButton.new() 
						newButton.setAction(i,event);
						Buttons.append(newButton);
						add_child(newButton);
						newButton.setupSignals()
##So the scrolling doesn't jump up to the quit button
func setFocusOrder():
	for b in Buttons:		##For smooth list scrollings
		var previous = get_children()[b.get_index()-1]
		var previousPath
		if(previous.visible == true): ##Skipping over invisible controls for focus
			previousPath = previous.get_path()
		else:
			previousPath =get_children()[b.get_index()-2].get_path()
		b.set_focus_neighbor(SIDE_TOP,previousPath)
		b.set_focus_previous(previousPath)
	if(selectedMethod == inputMethod.controller): ##Ensuring proper flow with the sensitiviy slider
		var first = Buttons[0];
		first.set_focus_neighbor(SIDE_TOP,ControllerSensitivity.sensitivitySlider.get_path())
		first.set_focus_previous(ControllerSensitivity.sensitivitySlider.get_path())
	scrollContainer.scroll_vertical = 0; ##Ensuring the container is always at the top once loaded
func _on_key_type_selection_item_selected(index):
	TTS.addText(inputTypeSelect.get_item_text(index),true)
	if(index == 0):
		ControllerSensitivity.visible = false;
		setKeyBoardButtons();
		selectedMethod = inputMethod.keyboard;
	if(index == 1):
		ControllerSensitivity.visible = true;
		setControllerButtons();
		selectedMethod = inputMethod.controller;
	move_child(settingsButton,get_child_count())
	setFocusOrder()
	
##Identifies the players first controller for the purposes of Displaying keybindings
func identifyController():
	var joys = Input.get_connected_joypads();
	if(joys.size() >0):
		if(Input.is_joy_known(joys[0])):
			var joyName:String = Input.get_joy_name(joys[0])
			joyName = joyName.to_lower()
			print(joyName)
			if(joyName.contains("sony") or joyName.contains("playstation") or joyName.contains("ps")):
				KeyButton.controllerID = KeyButton.controllerType.Sony
			elif(joyName.contains("xinput") or joyName.contains("xbox")):
				KeyButton.controllerID = KeyButton.controllerType.Xbox
			elif(joyName.contains("nintendo") or joyName.contains("switch") or joyName.contains("nes")):
				KeyButton.controllerID = KeyButton.controllerType.Xbox
		else:
			KeyButton.controllerID = KeyButton.controllerType.Unknown
	else:
		KeyButton.controllerID = KeyButton.controllerType.Unknown
func _on_key_type_selection_focus_entered():
	var string = "Input type selector " + getPositionString()
	TTS.addText(string,true)

func _on_settings_button_focus_entered():
	var string = "Settings " + getPositionString()
	TTS.addText(string,true)


func _on_visibility_changed():
	if(visible):
		inputTypeSelect.grab_focus()


func _on_reset_focus_entered():
	var string = "Reset to defaults " + getPositionString()
	TTS.addText(string,true)


func _on_reset_pressed():
	var string = "Reseting to defaults"
	TTS.addText(string,true)
	InputMap.load_from_project_settings()
	Saver.keyBindsReset()
	Saver.saveKeyBinds()
	if(selectedMethod == inputMethod.keyboard):
		setKeyBoardButtons()
	elif(selectedMethod == inputMethod.controller):
		setControllerButtons()
	move_child(settingsButton,get_child_count())
	setFocusOrder()
func _on_key_type_selection_item_focused(index):
	var string = inputTypeSelect.get_item_text(index) +" "+ str(index+1) + " of "+ str(inputTypeSelect.item_count)
	TTS.addText(string,true)

func getPositionString() -> String:
	var currentFocus = get_viewport().gui_get_focus_owner()
	var string =  str(currentFocus.get_index() +1) +" of " + str(currentFocus.get_parent().get_child_count()) 
	return string


func _on_controller_sensitivity_focus_entered():
	var string = "Controller Sensitivity " + str(ControllerSensitivity.sensitivity) + " 3 of " +str(get_child_count()) 
	TTS.addText(string,true);


func _on_advanced_buttons_toggled(toggled_on):
	advancedBindings = toggled_on
	var string = "Advanced Bindings enabled"
	TTS.addText(string,true)
	if(selectedMethod == inputMethod.keyboard):
		setKeyBoardButtons()
	elif(selectedMethod == inputMethod.controller):
		setControllerButtons()
	move_child(settingsButton,get_child_count())
	setFocusOrder()

func _on_advanced_buttons_focus_entered():
	var string = "Advanced Bindings " + getPositionString()
	TTS.addText(string,true)
