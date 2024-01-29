extends Control

@export var startMenu:Control
@export var levelSelect:Control
func startGame():
	Loader.loadLevel(0);

func quit():
	get_tree().quit();	


func _on_back_button_pressed():
	levelSelect.visible = false;
	startMenu.visible = true;


func _on_level_select_pressed():
	levelSelect.visible = true;
	startMenu.visible = false;