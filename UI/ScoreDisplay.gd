class_name ScoreDisplay extends Label

var totalScore:int = 0;
@export var BuildingScore:int;
@export var LikesBonus:int;
@export var likeAnimation:PackedScene;

func updateScore(map:TileMap,buildings:Array[Vector2i]):
	for t in buildings:
		var currentScore = BuildingScore;
		var numLikes = 0;
		if(map.get_cell_tile_data(0,t)!= null):
			var id = map.get_cell_tile_data(0,t).get_custom_data("BuildingID")
			var neighbours = map.get_surrounding_cells(t);
			var scored:bool = false;
			for n in neighbours:
				if (map.get_cell_tile_data(0,n)!= null):
					var neighbourId = map.get_cell_tile_data(0,n).get_custom_data("BuildingID")
					if Building.likesArray[id][neighbourId]:
						numLikes +=1;
						scored = true;
			if(scored):
				animateLike(t,map);
			currentScore += numLikes*numLikes*LikesBonus;
			totalScore += currentScore;
			text = "Score: " + str(totalScore);
##			await get_tree().create_timer(0.2).timeout ##Currently produces a bug where streets are counted as it happens during street placing

func levelEnd():
	set_anchors_preset(Control.PRESET_CENTER_TOP,true);

func animateLike(location:Vector2i,map:TileMap):
	var animation = likeAnimation.instantiate()
	animation.position = map.map_to_local(location);
	get_tree().root.add_child(animation)
