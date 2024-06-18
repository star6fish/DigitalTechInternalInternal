extends Node2D
	
var RotateDirection = 0.2
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position.x -= 500 * delta
	
	if rotation >= RotateDirection:
		RotateDirection = -0.2
	elif  rotation <= -RotateDirection:
		RotateDirection = 0.2
		
	rotation = rotate_toward(rotation, RotateDirection, delta * 2)
