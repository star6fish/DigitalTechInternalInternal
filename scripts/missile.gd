extends Node2D

@export var explosion_scene : PackedScene
@export var explosion_colour : Color

var rotate_direction = 0.2
var crashing = false

var explosion = false
	
func _hit_object(object):
	if (object.get_parent().name == "CharacterBody2D"
	and object.name != "ObstacleDetector"
	or object.has_meta("Bullet")):
		
		crashing = true
		
		explosion = explosion_scene.instantiate()
		
		explosion.position.x = position.x
		explosion.position.y = position.y
		
		explosion.get_child(0).modulate = explosion_colour
		explosion.get_child(1).color = explosion_colour
		
		get_parent().add_child(explosion)
		
		queue_free()
		
	elif object.name == "ObstaclePassDetector":
		queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position.x -= 500 * delta
	
	if crashing == true:
		
		explosion.position.x = position.x
		explosion.position.y = position.y
		
	elif crashing == false:
	
		if rotation >= rotate_direction:
			rotate_direction = -0.2
		elif  rotation <= -rotate_direction:
			rotate_direction = 0.2
		
		rotation = rotate_toward(rotation, rotate_direction, delta * 2)
