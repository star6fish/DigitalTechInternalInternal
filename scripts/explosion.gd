extends Node2D

@export var explosion_particles : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var particles = explosion_particles.instantiate()
	
	particles.position = position
	particles.rotation = rotation
	particles.emitting = true
	
	get_tree().current_scene.add_child(particles)
	
	await get_tree().create_timer(2).timeout
	
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.play()
