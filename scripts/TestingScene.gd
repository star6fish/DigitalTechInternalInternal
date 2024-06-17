extends Node2D

@export var ObstacleScene: PackedScene

var obstacleCoolDown = false

func _spawn_obstacle():
	
	obstacleCoolDown = true
	
	var Obstacle = ObstacleScene.instantiate()
	
	Obstacle.position.x = $CharacterBody2D.position.x + 2000
	Obstacle.position.y = randf_range($CharacterBody2D.position.y - 50, $CharacterBody2D.position.y + 50)
	
	add_child(Obstacle)
	
	await get_tree().create_timer(1.0).timeout
	
	obstacleCoolDown = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if obstacleCoolDown == false:
		_spawn_obstacle()
