class_name KeyMenu extends VBoxContainer
#Keybindings menu
#Handles selecting which type of controls the player can select to modify

enum inputMethod {keyboard,controller}
var selectedMethod:inputMethod = inputMethod.keyboard;

@export var Buttons:Array[KeyButton];
var actions:Array[StringName];

@export var inputTypeSelect:OptionButton
@export var settingsButton:Button;

@export var includedButtons:Array[StringName]

func _ready():
	actions = InputMap.get_actions();
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

##So the scrolling doesn't jump up to the quit button
func setFocusOrder():
	for b in Buttons:		##For smooth list scrollings
		var previous = get_children()[b.get_index()-1].get_path()
		b.set_focus_neighbor(SIDE_TOP,previous)
		b.set_focus_previous(previous)

func _on_key_type_selection_item_selected(index):
	TTS.addText(inputTypeSelect.get_item_text(index),true)
	if(index == 0):
		setKeyBoardButtons();
		selectedMethod = inputMethod.keyboard;
	if(index == 1):
		setControllerButtons();
		selectedMethod = inputMethod.controller;
	move_child(settingsButton,get_child_count())
	setFocusOrder()
	
func _on_key_type_selection_focus_entered():
	var string = "Input type selector " + getPositionString()
	TTS.addText(string,true)

func _on_settings_button_focus_entered():
	var string = "Settings " + getPositionString()
	TTS.addText(string,true)


func _on_visibility_changed():
	if(visible):
		print("keybinds menu visible")
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
