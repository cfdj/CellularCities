class_name ScoreDisplay extends Label

var totalScore:int = 0;
@export var BuildingScore:int;
@export var LikesBonus:int;

func updateScore(map:TileMap,buildings:Array[Vector2i]):
	for t in buildings:
		var currentScore = BuildingScore;
		var numLikes = 0;
		if(map.get_cell_tile_data(0,t)!= null):
			var id = map.get_cell_tile_data(0,t).get_custom_data("BuildingID")
			var neighbours = map.get_surrounding_cells(t);
			for n in neighbours:
				if (map.get_cell_tile_data(0,n)!= null):
					var neighbourId = map.get_cell_tile_data(0,n).get_custom_data("BuildingID")
					if Building.likesArray[id][neighbourId]:
						numLikes +=1;
			currentScore += numLikes*numLikes*LikesBonus;
			totalScore += currentScore;
			text = "Score: " + str(totalScore);
