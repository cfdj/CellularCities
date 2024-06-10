extends TileMap

@export var tileLoadShader:ShaderMaterial;
@export var buildingLoadShader:ShaderMaterial;
var progress:float = 1;
var buildingprogress:float = 1;
func _process(delta):
	if(progress >0):
		progress = lerpf(progress,0,0.2)
		if(abs(progress) < 0.0001):
			progress = 0;
		tileLoadShader.set_shader_parameter("progress",progress)
	else:
		if(buildingprogress>0):
			buildingprogress = lerpf(buildingprogress,0,0.2)
			buildingLoadShader.set_shader_parameter("progress",buildingprogress)
