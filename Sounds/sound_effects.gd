class_name AudioManager extends AudioStreamPlayer

@export var cantPlace:AudioStream
@export var levelComplete:AudioStream
@export var music:AudioStream;

@export var buildingSoundEffects:Array[AudioStream];
static var volume:float
func cantSound():
	stream = cantPlace
	volume_db = volume;
	if volume > -80:
		play()

func levelDoneSound():
	stream = levelComplete
	volume_db = volume;
	if volume > -80:
		play()

func buildingSound(buildingId:int):
	if(buildingId < buildingSoundEffects.size()):
		stream = buildingSoundEffects[buildingId]
		volume_db = volume;
		if volume > -80:
			play()
