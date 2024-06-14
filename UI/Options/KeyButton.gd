class_name KeyButton extends Button

var action:StringName
var input:InputEvent
var labelString:String

var listening:bool = false;
static var controllerID:controllerType = controllerType.Unknown
enum controllerType{Unknown,Sony,Xbox,Nintendo}
#var pressedStyle = "res://UI/Theme/toggleButtonPressed.tres"

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
		buttonId = buttonId.replace("Joypad Button", "") 
		buttonId = buttonId.replace("(","")
		buttonId = buttonId.replace(")","")
		var controllerNames = buttonId.split(",")
		if(controllerNames.size()>1):
			var sonyFixOffset = 0;
			if(input.as_text().contains("Start")&&controllerID != controllerType.Unknown):
				sonyFixOffset = 1;
			buttonId = controllerNames[controllerID - sonyFixOffset]
			##Slight Hack fix for Start Buttons, as Sony Doesn't have one???
	elif input is InputEventJoypadMotion:
		buttonId = input.as_text()
		var removing = buttonId.rfind(",")
		buttonId = buttonId.trim_suffix(buttonId.substr(removing))
		buttonId = buttonId.trim_prefix(buttonId.left(buttonId.find("(")+1))
	elif input is InputEventMouseButton:
		var mask = input.button_index
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
	var string = "Rebinding " +action
	TTS.addText(string,true)
	await get_tree().process_frame ##Making it wait until the initial input which pressed the button has passed
	listening = true;
	
func _input(event):
	if(listening):
		get_viewport().set_input_as_handled() ##Saying "Hey, I've got this!" so it doesn't effect the rest of the menu
	##This might not work the way I'm hoping due to scene tree ordering
	##It probably needs moved to the scene root, maybe an autoload
		if(!event.is_action_pressed("Quit")):
			if(event.is_action_type()):
				print("Input rebound")
				InputMap.action_erase_event(action,input);
				InputMap.action_add_event(action,event);
				set_pressed_no_signal(false);
				setAction(action,event);
				listening = false;
				Saver.markRebind(action)
				Saver.saveKeyBinds()
		else:
			set_pressed_no_signal(false);
			listening = false;
			var string = "Rebind cancelled"
			TTS.addText(string,true)


func _on_focus_exited():
	listening = false; ##Making it so that if focus changes it stops trying to change event
	set_pressed_no_signal(false);


func _on_focus_entered():
	var string = labelString +" " +str(get_index()+1) +" of " + str(get_parent().get_child_count());
	TTS.addText(string,true);

func setupSignals():
	toggle_mode = true
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	pressed.connect(listenForNewAction)
	#var styleBox:StyleBoxFlat = load("res://UI/Theme/toggleButtonPressed.tres")
	add_theme_color_override("font_pressed_color",Color.BLACK)


func _exit_tree():
	focus_entered.disconnect(_on_focus_entered)
	focus_exited.disconnect(_on_focus_exited)
	pressed.disconnect(listenForNewAction)
