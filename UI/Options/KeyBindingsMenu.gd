class_name KeyMenu extends VBoxContainer
#Keybindings menu
#Handles selecting which type of controls the player can select to modify

enum inputMethod {keyboard,controller}
var selectedMethod:inputMethod = inputMethod.keyboard;

@export var Buttons:Array[KeyButton];
@export var pressedStyle:StyleBoxFlat
var actions:Array[StringName];

@export var inputTypeSelect:OptionButton

@export var includedButtons:Array[StringName]
func _ready():
	actions = InputMap.get_actions();
	setKeyBoardButtons();
	inputTypeSelect.add_item("Keyboard bindings")
	inputTypeSelect.add_item("Controller bindings")
	
	
func setKeyBoardButtons():
	for i in Buttons: ##Clearing the array of any already placed buttons
		i.queue_free()
	Buttons.clear();
	for i in includedButtons:
		for event in InputMap.action_get_events(i):
			if(event is InputEventKey):
				var newButton = KeyButton.new();
				newButton.setAction(i,event);
				Buttons.append(newButton);
				add_child(newButton)
				newButton.setupSignals(pressedStyle)

func setControllerButtons():
	for i in Buttons: ##Clearing the array of any already placed buttons
		i.queue_free()
	Buttons.clear();
	for i in includedButtons:
		for event in InputMap.action_get_events(i):
			if(event is InputEventJoypadButton):
				var newButton = KeyButton.new();
				newButton.setAction(i,event);
				Buttons.append(newButton);
				add_child(newButton);
				newButton.setupSignals(pressedStyle)

func _on_key_type_selection_item_selected(index):
	TTS.addText(inputTypeSelect.get_item_text(index),true)
	if(index == 0):
		setKeyBoardButtons();
		selectedMethod = inputMethod.keyboard;
	if(index == 1):
		setControllerButtons();
		selectedMethod = inputMethod.controller;


func _on_key_type_selection_focus_entered():
	TTS.addText("Input type selector",true)

func _on_settings_button_focus_entered():
	TTS.addText("Settings",true)


func _on_visibility_changed():
	if(visible):
		inputTypeSelect.grab_focus()


func _on_reset_focus_entered():
	var string = "Reset to defaults"
	TTS.addText(string,true)


func _on_reset_pressed():
	var string = "Reseting to defaults"
	TTS.addText(string,true)
	InputMap.load_from_project_settings()
	if(selectedMethod == inputMethod.keyboard):
		setKeyBoardButtons()
	elif(selectedMethod == inputMethod.controller):
		setControllerButtons()


func _on_key_type_selection_item_focused(index):
	var string = inputTypeSelect.get_item_text(index)
	TTS.addText(string,true)
