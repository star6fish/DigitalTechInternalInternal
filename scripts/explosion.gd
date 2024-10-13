extends Node2D

@export var ExplosionParticles : PackedScene

func _ready():
	var _particles = ExplosionParticles.instantiate()
	
	_particles.position = position
	_particles.rotation = rotation
	_particles.emitting = true
	
	get_tree().current_scene.add_child(_particles)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.play()
