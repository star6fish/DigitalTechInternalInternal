extends Node2D

@export var explosion_scene : PackedScene
@export var explosion_colour : Color

var crashing = false

var explosion = false


func _hit_object(object):
	if (object.get_parent().name == "CharacterBody2D"
	and object.name != "ObstacleDetector"
	or object.has_meta("Bullet")):
		
		crashing = true
		
		explosion = explosion_scene.instantiate()
		
		explosion.position.x = object.position.x
		explosion.position.y = object.position.y + 20
		
		explosion.get_child(0).modulate = explosion_colour
		explosion.get_child(1).color = explosion_colour
		
		get_parent().add_child(explosion)
		
	elif object.name == "ObstaclePassDetector":
		queue_free()
		
