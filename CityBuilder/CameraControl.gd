extends Camera2D

@export var speed:float;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var horizontal = Input.get_axis("Left","Right");
	var vertical = Input.get_axis("Up","Down")
	position+= Vector2(horizontal,vertical)*speed;
