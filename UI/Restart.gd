extends Button

func _ready():
	grab_focus();
	var string = "Thanks for playing, press space to return to title"
	TTS.addText(string,true)
func _on_pressed():
	get_tree().change_scene_to_file("res://UI/StartMenu.tscn")
