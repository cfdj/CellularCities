class_name KeyButton extends Button

var action:StringName
var input:InputEvent
var labelString:String

var listening:bool = false;

	
func setAction(newAction:StringName,newInput:InputEvent):
	action = newAction;
	input = newInput;
	var buttonId;
	if input is InputEventKey:
		buttonId = OS.get_keycode_string(input.physical_keycode)
		if(buttonId == ""):
			buttonId= input.as_text()
	elif input is InputEventJoypadButton:
		buttonId = input.as_text()
	elif input is InputEventJoypadMotion:
		buttonId = input.as_text()
	elif input is InputEventMouseButton:
		var mask = input.button_mask
		match mask:
			1:
				buttonId = "Left Mouse"
			2:
				buttonId = "Right Mouse"
			3:
				buttonId = "Middle Mouse"
			4:
				buttonId = "Wheel up"
			5:
				buttonId = "Wheel down"
			6:
				buttonId = "Wheel Left"
			7:
				buttonId = "Wheel right"
			8:
				buttonId = "Extra 1"
			9:
				buttonId = "Extra 2"
	labelString = action + ": " + str(buttonId);
	text = labelString;

func listenForNewAction():
	await get_tree().process_frame ##Making it wait until the initial input which pressed the button has passed
	listening = true;
	
func _input(event):
	if(listening):
		get_viewport().set_input_as_handled() ##Saying "Hey, I've got this!" so it doesn't effect the rest of the menu
	##This might not work the way I'm hoping due to scene tree ordering
	##It probably needs moved to the scene root, maybe an autoload
		if(!event.is_action_pressed("Quit")):
			if(event.is_action_type()):
				print("Changing Input")
				InputMap.action_erase_event(action,input);
				InputMap.action_add_event(action,event);
				set_pressed_no_signal(false);
				setAction(action,event);
				listening = false;
		else:
			set_pressed_no_signal(false);
			listening = false;


func _on_focus_exited():
	listening = false; ##Making it so that if focus changes it stops trying to change event
	set_pressed_no_signal(false);
