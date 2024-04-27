extends Panel

@export var control1:Control;

@export var volume:Slider;
@export var TTSVolume:Slider;
@export var TTSRate:Slider;
@export var keyboardToggle:CheckButton;
@export var TTSToggle:CheckButton;

@export var TTSVoiceSelector:OptionButton;
func _ready():
	control1.grab_focus()
	volume.set_value_no_signal(AudioManager.volume);
	TTSVolume.set_value_no_signal(TTS.volume);
	TTSRate.set_value_no_signal(TTS.speed);
	keyboardToggle.set_pressed_no_signal(!LevelManager.mouse)
	TTSToggle.set_pressed_no_signal(TTS.enabled)
	
	var voices = DisplayServer.tts_get_voices_for_language("en")
	for v in range(voices.size()):
		TTSVoiceSelector.add_item("Voice " + str(v))
func speakCurrentOption():
	var current:Control = get_viewport().gui_get_focus_owner()
	if(current !=null && current.visible):
		TTS.addText(current.name,true)

func _on_volume_control_drag_ended(value_changed):
	var value = volume.value
	AudioManager.volume = value
	TTS.addText(str(value),true)

func _on_text_to_speech_enable_toggled(toggled_on):
	TTS.enabled = toggled_on
	TTS.addText(str(toggled_on),true)

func _on_tts_volume_control_drag_ended(value_changed):
	var value = TTSVolume.value
	TTS.volume = value;
	TTS.addText(str(value),true)

func _on_tts_rate_control_drag_ended(value_changed):
	var value = TTSRate.value
	TTS.speed = value
	TTS.addText(str(value),true)

func _on_keyboard_toggled(toggled_on):
	LevelManager.mouse = !toggled_on;
	TTS.addText(str(toggled_on),true)

func _on_visibility_changed():
	if(visible&& control1.is_visible_in_tree()):
		control1.grab_focus()
		speakCurrentOption()


func _on_volume_control_value_changed(value):
	AudioManager.volume = value;
	TTS.addText(str(value),true);
func _on_tts_volume_control_value_changed(value):
	TTS.volume = value
	TTS.addText(str(value),true);
func _on_tts_rate_control_value_changed(value):
	TTS.speed = value
	TTS.addText(str(value),true);


func _on_voice_selector_item_selected(index):
	TTS.voice = index;
	TTS.vString = DisplayServer.tts_get_voices_for_language("en")[index];
	var string ="Voice " + str(index) + "selected"
	TTS.addText(string,true);


func _on_voice_selector_item_focused(index):
	var string ="Voice " + str(index)
	TTS.addText(string,true)


func _on_voice_selector_focus_entered():
	var string = "Voice selector"
	TTS.addText(string,true);
