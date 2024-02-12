class_name AudioManager extends AudioStreamPlayer

@export var cantPlace:AudioStream
@export var levelComplete:AudioStream
@export var music:AudioStream;

func cantSound():
	stream = cantPlace
	play()

func levelDoneSound():
	stream = levelComplete
	play()
