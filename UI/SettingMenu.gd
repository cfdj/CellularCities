extends Panel

@export var control1:Control;

@export var volume:Slider;
@export var TTSVolume:Slider;
@export var TTSRate:Slider;
@export var Voice:SpinBox;
@export var keyboardToggle:CheckButton;
@export var TTSToggle:CheckButton;
func _ready():
	control1.grab_focus()
	Voice.max_value = DisplayServer.tts_get_voices_for_language("en").size()-1;
	volume.set_value_no_signal(AudioManager.volume);
	TTSVolume.set_value_no_signal(TTS.volume);
	TTSRate.set_value_no_signal(TTS.speed);
	Voice.set_value_no_signal(TTS.voice);
	keyboardToggle.set_pressed_no_signal(!LevelManager.mouse)
	TTSToggle.set_pressed_no_signal(TTS.enabled)
func speakCurrentOption():
	var current:Control = get_viewport().gui_get_focus_owner()
	if(current !=null && current.visible):
		TTS.addText(current.name)


func _on_volume_control_drag_ended(value_changed):
	var value = volume.value
	AudioManager.volume = value
	TTS.addText(str(value))

func _on_text_to_speech_enable_toggled(toggled_on):
	TTS.enabled = toggled_on
	TTS.addText(str(toggled_on))

func _on_tts_volume_control_drag_ended(value_changed):
	var value = TTSVolume.value
	TTS.volume = value;
	TTS.addText(str(value))

func _on_tts_rate_control_drag_ended(value_changed):
	var value = TTSRate.value
	TTS.speed = value
	TTS.addText(str(value))

func _on_keyboard_toggled(toggled_on):
	LevelManager.mouse = !toggled_on;
	TTS.addText(str(toggled_on))

func _on_visibility_changed():
	if(visible):
		control1.grab_focus()
		speakCurrentOption()


func _on_voice_select_value_changed(value):
	TTS.voice = value;
	TTS.addText(str(value));
