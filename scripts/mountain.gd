extends Node2D

@export var ExplosionScene : PackedScene
@export var ExplosionColour : Color

var Crashing = false

var Explosion = false

func _hitobject(object):
	if object.get_parent().name == "CharacterBody2D":
		
		Crashing = true
		
		Explosion = ExplosionScene.instantiate()
		
		Explosion.position.x = object.position.x
		Explosion.position.y = object.position.y + 20
		
		Explosion.get_child(0).modulate = ExplosionColour
		Explosion.get_child(1).color = ExplosionColour
		
		get_parent().add_child(Explosion)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
