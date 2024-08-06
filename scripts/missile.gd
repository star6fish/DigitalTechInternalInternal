extends Node2D

@export var ExplosionScene : PackedScene
@export var ExplosionColour : Color

var RotateDirection = 0.2
var Crashing = false

var Explosion = false
	
func _hitobject(object):
	if object.get_parent().name == "CharacterBody2D":
		
		Crashing = true
		
		Explosion = ExplosionScene.instantiate()
		
		Explosion.position.x = position.x
		Explosion.position.y = position.y
		
		Explosion.get_child(0).modulate = ExplosionColour
		Explosion.get_child(1).color = ExplosionColour
		
		get_parent().add_child(Explosion)

	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position.x -= 500 * delta
	
	if Crashing == true:
		
		Explosion.position.x = position.x
		Explosion.position.y = position.y
		
	elif Crashing == false:
	
		if rotation >= RotateDirection:
			RotateDirection = -0.2
		elif  rotation <= -RotateDirection:
			RotateDirection = 0.2
		
		rotation = rotate_toward(rotation, RotateDirection, delta * 2)
