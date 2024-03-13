extends ItemList

func _ready():
	for l in Loader.levels:
		var name = str(l);
		name = name.rstrip(".tscn");
		name = name.lstrip("res://Levels/")
		add_item(name);


func _on_item_selected(index):
	if(TTS.enabled):
		TTS.addText(get_item_text(index))
##res://Levels/Train1.tscn


func _on_item_activated(index):
	Loader.loadLevel(index);


func _on_visibility_changed():
	if (visible):
		grab_focus()
		select(0)
		TTS.addText(get_item_text(0))
