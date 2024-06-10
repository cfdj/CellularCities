class_name SettingMenu extends PanelContainer

@export var control1:Control;

@export var volume:Slider;
@export var TTSVolume:Slider;
@export var TTSRate:Slider;
@export var keyboardToggle:CheckButton;
@export var TTSToggle:CheckButton;

@export var TTSVoiceSelector:OptionButton;
var mouse;
@export_category("Sub menus")
@export var SettingsContainer:Control;
@export var KeyBindingsContainer:Control;
func _ready():
	volume.set_value_no_signal(SoundEffects.getVolume());
	TTSVolume.set_value_no_signal(TTS.volumeGet());
	TTSRate.set_value_no_signal(TTS.speedGet());
	mouse = Saver.getSettingValue("Mouse")
	if(mouse == null):
		mouse = LevelManager.mouse
		Saver.save("Mouse",mouse)
	LevelManager.mouse = mouse;
	keyboardToggle.set_pressed_no_signal(!mouse)
	TTSToggle.set_pressed_no_signal(TTS.enabledGet())
	print("Setting voices")
	var voices = DisplayServer.tts_get_voices_for_language("en")
	for v in range(voices.size()):
		TTSVoiceSelector.add_item("Voice " + str(v+1))

func speakCurrentOption():
	var current:Control = get_viewport().gui_get_focus_owner()
	if(current !=null && current.visible):
		var string = current.name + " " + getPositionString(current)
		TTS.addText(string,true)

func _on_volume_control_drag_ended(value_changed):
	var value = volume.value
	SoundEffects.setVolume(value)
	TTS.addText(str(value),true)

func _on_text_to_speech_enable_toggled(toggled_on):
	TTS.enabledSet(toggled_on)
	TTS.addText(str(toggled_on),true)

func _on_tts_volume_control_drag_ended(value_changed):
	var value = TTSVolume.value
	TTS.volumeSet(value);
	TTS.addText(str(value),true)

func _on_tts_rate_control_drag_ended(value_changed):
	var value = TTSRate.value
	TTS.speedSet(value)
	TTS.addText(str(value),true)

func _on_keyboard_toggled(toggled_on):
	LevelManager.mouse = !toggled_on;
	TTS.addText(str(toggled_on),true)
	Saver.save("Mouse",!toggled_on);

func _on_visibility_changed():
	if(visible):
		control1.grab_focus()
		#speakCurrentOption()


func _on_volume_control_value_changed(value):
	SoundEffects.setVolume(value);
	TTS.addText(str(value),true);
func _on_tts_volume_control_value_changed(value):
	TTS.volumeSet(value)
	TTS.addText(str(value),true);
func _on_tts_rate_control_value_changed(value):
	TTS.speedSet(value)
	TTS.addText(str(value),true);


func _on_voice_selector_item_selected(index):
	TTS.voice = index;
	TTS.voiceSet(DisplayServer.tts_get_voices_for_language("en")[index]);
	var string ="Voice " + str(index+1) + " selected"
	TTS.addText(string,true);


func _on_voice_selector_item_focused(index):
	var string ="Voice " + str(index+1) + " of " +str(TTSVoiceSelector.item_count)
	TTS.addText(string,true)

func _on_key_bindings_button_pressed():
	var string = "Opening key bindings menu"
	TTS.addText(string,true)
	SettingsContainer.visible = false;	
	KeyBindingsContainer.visible = true;
	
	#set_size(Vector2(256+160,216),true)
	#set_position(Vector2(115-94,105))
	#set_anchors_preset(Control.PRESET_CENTER_BOTTOM,false)

func _on_settings_button_pressed():
	var string = "Opening settings"
	SettingsContainer.visible = true;
	KeyBindingsContainer.visible = false;
	control1.grab_focus()

	#set_size(Vector2(128,216),true)
	#set_position(Vector2(179,105))
	#control1.grab_focus()

func getPositionString(current:Control) ->String:
	var SettingsChildren = SettingsContainer.get_children()
	var focusables:Array[Control]
	for f in SettingsChildren:
		if((f as Control).focus_mode != FOCUS_NONE):
			focusables.append(f);
	var string = str(focusables.find(current)+1) + " of " + str(focusables.size())
	return string


func _on_voice_selector_pressed():
	var string ="Voice " + str(TTSVoiceSelector.selected+1) + " of " +str(TTSVoiceSelector.item_count)
	TTS.addText(string,true)
