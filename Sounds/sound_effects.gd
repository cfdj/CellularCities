class_name AudioManager extends AudioStreamPlayer

@export var cantPlace:AudioStream
@export var levelComplete:AudioStream
@export var music:AudioStream;

@export var buildingSoundEffects:Array[AudioStream];
var volume:float
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

func setVolume(value):
	volume = value
	Saver.save("Volume",value)
func getVolume():
	var value = Saver.getSettingValue("Volume")
	if(value == null):
		setVolume(volume)
	else:
		volume = value
	return volume
