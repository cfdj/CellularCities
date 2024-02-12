extends ItemList

func _ready():
	for l in Loader.levels:
		var name = str(l);
		name = name.rstrip(".tscn");
		name = name.lstrip("res://Levels/")
		add_item(name);
	get_children()[0].grab_focus()



func _on_item_selected(index):
	Loader.loadLevel(index);
##res://Levels/Train1.tscn
