class_name SensitivitySlider extends SplitContainer

var sensitivity:float = 0.5

@export var sensitivitySlider:HSlider


func _on_controller_sensitivity_visibility_changed():
	var savedSensitivity = Saver.getSettingValue("Sensitivity")
	if(savedSensitivity != null):
		sensitivitySlider.set_value_no_signal(savedSensitivity)
		sensitivity = savedSensitivity
		setDeadZones()
	else:
		sensitivitySlider.set_value_no_signal(sensitivity)


func _on_controller_sensitivity_value_changed(value):
	TTS.addText(str(value),true)
	sensitivity = value
	Saver.save("Sensitivity",sensitivity)

func setDeadZones():
	var controllerInputs = InputMap.get_actions()
	for a in controllerInputs:
		InputMap.action_set_deadzone(a,sensitivity)

##Deadzone is save on leaving the slider for debounce purposes
func _on_controller_sensitivity_focus_exited():
	setDeadZones()
