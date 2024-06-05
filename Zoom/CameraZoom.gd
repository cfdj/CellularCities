class_name CameraZoom extends Camera2D

var baseOffsetX = 240
var baseOffsetY = 160
var currentCenter:Vector2=Vector2(240,160)

var zoomLevels:Array[Vector2] = [Vector2(1,1),Vector2(2,2),Vector2(4,4)]
var currentLevel = 0;
var level:LevelManager

func _input(event):
	if(level.playing):
		if(event.is_action_pressed("ZoomIn")):
			zoomIn()
		elif (event.is_action_pressed("ZoomOut")):
			zoomOut()

func zoomIn():
	currentLevel+=1;
	offset = currentCenter
	if(currentLevel>zoomLevels.size()-1):
		currentLevel = zoomLevels.size()-1
	zoom = zoomLevels[currentLevel]

func zoomOut():
	currentLevel-=1;
	if(currentLevel<=0):
		currentLevel = 0;
		offset = Vector2(baseOffsetX,baseOffsetY)
	zoom = zoomLevels[currentLevel]

func move(center:Vector2):
	currentCenter = center;
	if(currentLevel>0):
		offset = center;
	else:
		offset = Vector2(baseOffsetX,baseOffsetY)
