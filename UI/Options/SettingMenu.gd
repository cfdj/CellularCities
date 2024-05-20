class_name SettingMenu extends Panel

@export var control1:Control;

@export var volume:Slider;
@export var TTSVolume:Slider;
@export var TTSRate:Slider;
@export var keyboardToggle:CheckButton;
@export var TTSToggle:CheckButton;

@export var TTSVoiceSelector:OptionButton;

@export_category("Sub menus")
@export var SettingsContainer:Control;
@export var KeyBindingsContainer:Control;
func _ready():
	volume.set_value_no_signal(SoundEffects.getVolume());
	TTSVolume.set_value_no_signal(TTS.volumeGet());
	TTSRate.set_value_no_signal(TTS.speedGet());
	var mouse = Saver.getSettingValue("Mouse")
	if(mouse == null):
		mouse = LevelManager.mouse
		Saver.save("Mouse",mouse)
	keyboardToggle.set_pressed_no_signal(!mouse)
	TTSToggle.set_pressed_no_signal(TTS.enabledGet())
	print("Setting voices")
	var voices = DisplayServer.tts_get_voices_for_language("en")
	for v in range(voices.size()):
		TTSVoiceSelector.add_item("Voice " + str(v))
	if(visible):
		control1.grab_focus()
func speakCurrentOption():
	var current:Control = get_viewport().gui_get_focus_owner()
	if(current !=null && current.visible):
		TTS.addText(current.name,true)

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

func _on_visibility_changed():
	if(visible&& control1.is_visible_in_tree()):
		control1.grab_focus()
		speakCurrentOption()


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
	var string ="Voice " + str(index) + "selected"
	TTS.addText(string,true);


func _on_voice_selector_item_focused(index):
	var string ="Voice " + str(index)
	TTS.addText(string,true)


func _on_voice_selector_focus_entered():
	var string = "Voice selector"
	TTS.addText(string,true);

func _on_key_bindings_button_pressed():
	var string = "Opening key bindings menu"
	TTS.addText(string,true)
	KeyBindingsContainer.visible = true;
	SettingsContainer.visible = false;	
	set_size(Vector2(256,216),true)
	set_position(Vector2(115,105))
	set_anchors_preset(Control.PRESET_CENTER_BOTTOM,false)
	
func _on_key_bindings_button_focus_entered():
	var string = "Key bindings menu"
	TTS.addText(string,true)


func _on_settings_button_pressed():
	var string = "Opening settings"
	SettingsContainer.visible = true;
	KeyBindingsContainer.visible = false;
	set_size(Vector2(128,216),true)
	set_position(Vector2(179,105))
	control1.grab_focus()