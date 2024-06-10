extends TileMap

@export var tileLoadShader:ShaderMaterial;
@export var buildingLoadShader:ShaderMaterial;
var progress:float = 1;

func _process(delta):
	if(progress >0):
		progress = lerpf(progress,0,0.2)
		if(progress < 0):
			progress = 0;
		tileLoadShader.set_shader_parameter("progress",progress)
		buildingLoadShader.set_shader_parameter("progress",progress)
