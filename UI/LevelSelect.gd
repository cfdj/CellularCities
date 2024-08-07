extends ItemList

func _ready():
	for l in Loader.levels:
		var name = str(l);
		var labelStart = name.rfind("/");
		name =name.substr(labelStart);
		name = name.rstrip(".tscn");
		name = name.lstrip("/")
		add_item(name);


func _on_item_selected(index):
	if(TTS.enabled):
		var string = get_item_text(index) + " " + str(index+1) +" of " + str(item_count)
		TTS.addText(string,true)
##res://Levels/Train1.tscn


func _on_item_activated(index):
	Loader.loadLevel(index);


func _on_visibility_changed():
	if (visible):
		grab_focus()
		select(0)
		var string =get_item_text(0) + " " + str(1) +" of " + str(item_count)
		TTS.addText(string,true)
