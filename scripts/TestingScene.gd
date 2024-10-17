extends Node2D

@export var ObstacleScene: PackedScene
@export var MountainScene: PackedScene
@export var MissileScene: PackedScene
@export var JetPlane_Obstacle1Scene: PackedScene
@export var JetPlane_Obstacle2Scene: PackedScene
@export var JetPlane_Obstacle3Scene: PackedScene
@export var JetPlane_Obstacle4Scene: PackedScene
@export var CactusScene: PackedScene
@export var JungleTree_Obstacle1Scene: PackedScene
@export var JungleTree_Obstacle2Scene: PackedScene

@onready var global = get_node("/root/Global")

var obstacleCoolDown = false
var obstacles = {}
var ShakeStrength = 0

func _pause():
	get_tree().paused = true
	$CanvasLayer.visible = false
	$CanvasLayer2.visible = true
	
func _resume():
	get_tree().paused = false
	$CanvasLayer2.visible = false
	$CanvasLayer.visible = true
	
func _home():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/PlayScreen.tscn")
	
func _pauseButtonPressed():
	_pause()

func _resumeButtonPressed():
	_resume()
	
func _homeButtonPressed():
	_home()
	
func _spawn_obstacle():
	
	obstacleCoolDown = true
	
	var Random = RandomNumberGenerator.new()
	Random.randomize()
	
	var ObstacleSelect = Random.randi_range(1, 3)
	
	if ObstacleSelect == 1:	
		if global.MapType == "Ocean":
			ObstacleSelect = MountainScene
		elif global.MapType == "Desert":
			ObstacleSelect = CactusScene
		elif global.MapType == "Jungle":
			
			var ObstacleJungleTreeType = Random.randi_range(1, 2)
			
			if ObstacleJungleTreeType == 1:
				ObstacleSelect = JungleTree_Obstacle1Scene
			elif ObstacleJungleTreeType == 2:
				ObstacleSelect = JungleTree_Obstacle2Scene
				
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
			
	var obstaclePositionY = clamp(randf_range($CharacterBody2D.position.y - 100, $CharacterBody2D.position.y + 100), -1000, -320)
		
	var canSpawn = true
			
	for obstacle in obstacles:
		if obstacles[obstacle] - obstaclePositionY < 10:
			canSpawn = false
			
	if ObstacleSelect == MountainScene or ObstacleSelect == JungleTree_Obstacle1Scene or ObstacleSelect == JungleTree_Obstacle2Scene:
		canSpawn = true
		obstaclePositionY = randf_range(100, 200)
	elif ObstacleSelect == CactusScene:
		
		if $RayCast2D.is_colliding():
			
			var RaycastInstance = $RayCast2D.get_collider()
			
			if RaycastInstance.has_meta("DesertRug"):
				obstaclePositionY = 650 - $RayCast2D.get_collision_point().y
			else:
				canSpawn = false
		else:
			canSpawn = false
				
	if canSpawn == true:
		
		var Obstacle = ObstacleSelect.instantiate()
		
		obstacles[Obstacle] = obstaclePositionY
				
		add_child(Obstacle)
			
		Obstacle.position.x = $CharacterBody2D.position.x + 2000
		Obstacle.position.y = obstaclePositionY
	
		var Double = Random.randi_range(1, 4)
	
		if Double == 4:
			_spawn_obstacle()
	
		if global.Difficulty == "Easy":
			await get_tree().create_timer(1).timeout
		elif global.Difficulty == "Normal":
			await get_tree().create_timer(0.5).timeout
		elif global.Difficulty == "Hard":
			await get_tree().create_timer(0.2).timeout		
			
		obstacles.erase(Obstacle)
	
	obstacleCoolDown = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	global.obstaclesDodged = 0
	if global.Difficulty == "Easy":
		$CanvasLayer.get_child(2).color = Color.DARK_GREEN
		$CanvasLayer.get_child(3).color = Color.GREEN
		$CanvasLayer.get_child(3).get_child(1).add_theme_color_override("font_color", Color.FLORAL_WHITE)
	elif global.Difficulty == "Normal":
		$CanvasLayer.get_child(2).color = Color.DARK_ORANGE
		$CanvasLayer.get_child(3).color = Color.ORANGE
		$CanvasLayer.get_child(3).get_child(1).add_theme_color_override("font_color", Color.PAPAYA_WHIP)
	if global.Difficulty == "Hard":
		$CanvasLayer.get_child(2).color = Color.DARK_RED
		$CanvasLayer.get_child(3).color = Color.RED
		$CanvasLayer.get_child(3).get_child(1).add_theme_color_override("font_color", Color.LIGHT_YELLOW)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$RayCast2D.position = Vector2($CharacterBody2D.position.x + 2000, -500)
	
	$Camera2D.position.x = $CharacterBody2D.position.x
	$Camera2D.position.y = clamp($CharacterBody2D.position.y, -600, -100)
	
	if $CharacterBody2D.position.x > 1600:
	
		if obstacleCoolDown == false:
			_spawn_obstacle()
			
	$CanvasLayer.get_child(4).text = "Obstacles Dodged:     " + str(global.obstaclesDodged)
			
	$CanvasLayer.get_child(3).position.x = -1152 * (1 - $CharacterBody2D.position.x / $Node2D3.position.x)
	$CanvasLayer.get_child(3).get_child(0).text = (str(floor($CharacterBody2D.position.x)) + " / " + str($Node2D3.position.x))
