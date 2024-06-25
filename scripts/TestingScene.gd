extends Node2D

@export var ObstacleScene: PackedScene
@export var MountainScene: PackedScene
@export var MissileScene: PackedScene
@export var JetPlane_Obstacle1Scene: PackedScene
@export var JetPlane_Obstacle2Scene: PackedScene
@export var JetPlane_Obstacle3Scene: PackedScene
@export var JetPlane_Obstacle4Scene: PackedScene

var obstacleCoolDown = false

func _spawn_obstacle():
	
	obstacleCoolDown = true
	
	var Random = RandomNumberGenerator.new()
	Random.randomize()
	
	var ObstacleSelect = Random.randi_range(1, 3)
	
	if ObstacleSelect == 1:
		ObstacleSelect = MountainScene
	elif ObstacleSelect == 2:
		ObstacleSelect = MissileScene
	elif ObstacleSelect == 3:
		
		var ObstacleJetPlaneColour = Random.randi_range(1, 3)
		
		if ObstacleJetPlaneColour == 1:
			ObstacleSelect = JetPlane_Obstacle1Scene
		elif ObstacleJetPlaneColour == 2:
			ObstacleSelect = JetPlane_Obstacle2Scene
		elif  ObstacleJetPlaneColour == 3:
			ObstacleSelect = JetPlane_Obstacle3Scene
			
	var Obstacle = ObstacleSelect.instantiate()
	
	if ObstacleSelect == MountainScene:
		Obstacle.position.x = $CharacterBody2D.position.x + 2000
		Obstacle.position.y = randf_range(100, 200)
	elif ObstacleSelect == MissileScene or ObstacleSelect == JetPlane_Obstacle1Scene or ObstacleSelect == JetPlane_Obstacle2Scene:
		Obstacle.position.x = $CharacterBody2D.position.x + 2000
		Obstacle.position.y = clamp(randf_range($CharacterBody2D.position.y - 100, $CharacterBody2D.position.y + 100), -1000, -320)
	
	add_child(Obstacle)
	
	var Double = Random.randi_range(1, 4)
	
	if Double == 4:
		_spawn_obstacle()
	
	await get_tree().create_timer(0.5).timeout
	
	obstacleCoolDown = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Camera2D.position.x = $CharacterBody2D.position.x
	$Camera2D.position.y = clamp($CharacterBody2D.position.y, -500, -100)
	
	if $CharacterBody2D.position.x > 1600:
	
		if obstacleCoolDown == false:
			_spawn_obstacle()
