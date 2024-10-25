extends Node2D

@export var obstacle_scene: PackedScene
@export var mountain_scene: PackedScene
@export var missile_scene: PackedScene
@export var jet_plane_obstacle1_scene: PackedScene
@export var jet_plane_obstacle2_scene: PackedScene
@export var jet_plane_obstacle3_scene: PackedScene
@export var jet_plane_obstacle4_scene: PackedScene
@export var cactus_scene: PackedScene
@export var jungle_tree_obstacle1_scene: PackedScene
@export var jungle_tree_obstacle2_scene: PackedScene

@onready var global = get_node("/root/Global")

var obstacle_cool_down = false
var obstacles = {}

const OBSTACLE_SPAWN_OFFSET_X = 2000
const OBSTACLE_SPAWN_DISTANCE_MINIMUM_Y = 10
const OBSTACLE_SPAWN_RANDOMNESS_Y = 50
const CACTUS_SPAWN_OFFSET_Y = 600
const OBSTACLE_CLAMP_Y_MINIMUM = -1000
const OBSTACLE_CLAMP_Y_MAXIMUM = -320
const MOUNTAIN_SPAWN_DISTANCE_MINIMUM_X = 20

const CAMERA_CLAMP_Y_MINIMUM = -600
const CAMERA_CLAMP_Y_MAXIMUM = -100

const TAKE_OFF_LEAVE_X = 1600


# Pause button pressed
func _pause():
	get_tree().paused = true
	$CanvasLayer.visible = false
	$CanvasLayer2.visible = true
	
	
# Resume button pressed
func _resume():
	get_tree().paused = false
	$CanvasLayer2.visible = false
	$CanvasLayer.visible = true
	
	
# Home button pressed
func _home():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/PlayScreen.tscn")

	
func _pause_button_pressed():
	_pause()
	

func _resume_button_pressed():
	_resume()
	
	
func _home_button_pressed():
	_home()
	
	
# Gets the position that an obstacle can spawn at
func _get_obstacle_spawn_position(obstacle_select):
	
	var can_spawn = true
	
	var obstacle_position = Vector2()
	
	var obstacle_position_x = $CharacterBody2D.position.x + OBSTACLE_SPAWN_OFFSET_X
	
	var obstacle_position_y = clamp(randf_range(
			$CharacterBody2D.position.y - OBSTACLE_SPAWN_RANDOMNESS_Y,
		 	$CharacterBody2D.position.y + OBSTACLE_SPAWN_RANDOMNESS_Y),
			OBSTACLE_CLAMP_Y_MINIMUM, OBSTACLE_CLAMP_Y_MAXIMUM)
			
	for obstacle in obstacles: # Checking if the obstacle position is too close to another obstacle
		if obstacles[obstacle] - obstacle_position_y < OBSTACLE_SPAWN_DISTANCE_MINIMUM_Y:
			can_spawn = false
	
	if obstacle_select == mountain_scene:
		
		for obstacle in obstacles: # Checking if the obstacle position is too close to another obstacle
			if (obstacles[obstacle] - $CharacterBody2D.position.x + OBSTACLE_SPAWN_OFFSET_X
					 < MOUNTAIN_SPAWN_DISTANCE_MINIMUM_X):
				can_spawn = false
		
		obstacle_position_y = randf_range(100, 200)
		
	elif (obstacle_select == jungle_tree_obstacle1_scene
	or obstacle_select == jungle_tree_obstacle2_scene):
		
		obstacle_position_y = randf_range(100, 200)
	
	elif obstacle_select == cactus_scene:
		
		# Raycast to see the Y position where the obstacles can spawn
		$RayCast2D.position = Vector2($CharacterBody2D.position.x + OBSTACLE_SPAWN_OFFSET_X,
				 CAMERA_CLAMP_Y_MINIMUM)
		
		if $RayCast2D.is_colliding():
			
			var raycast_instance = $RayCast2D.get_collider()
			
			if raycast_instance.has_meta("DesertRug"):
				obstacle_position_y = CACTUS_SPAWN_OFFSET_Y - $RayCast2D.get_collision_point().y
			else:
				can_spawn = false
		else:
			can_spawn = false
			
	obstacle_position = Vector2(obstacle_position_x, obstacle_position_y)
			
	if can_spawn == false:
		obstacle_position = false
	
	return obstacle_position
	
	
# Spawn an obstacle
func _spawn_obstacle():
	
	obstacle_cool_down = true
	
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	var obstacle_select = random.randi_range(1, 3)
	
	if obstacle_select == 1:	
		if global.map_type == "Ocean":
			obstacle_select = mountain_scene
		elif global.map_type == "Desert":
			obstacle_select = cactus_scene
		elif global.map_type == "Jungle":
			
			var obstacle_jungle_tree_type = random.randi_range(1, 2)
			
			if obstacle_jungle_tree_type == 1:
				obstacle_select = jungle_tree_obstacle1_scene
			elif obstacle_jungle_tree_type == 2:
				obstacle_select = jungle_tree_obstacle2_scene
				
	elif obstacle_select == 2:
		obstacle_select = missile_scene
	elif obstacle_select == 3:
		
		var obstacle_jet_plane_colour = random.randi_range(1, 3)
		
		if obstacle_jet_plane_colour == 1:
			obstacle_select = jet_plane_obstacle1_scene
		elif obstacle_jet_plane_colour == 2:
			obstacle_select = jet_plane_obstacle2_scene
		elif obstacle_jet_plane_colour == 3:
			obstacle_select = jet_plane_obstacle3_scene
			
	var obstacle_position = _get_obstacle_spawn_position(obstacle_select)
				
	if obstacle_position: # If the obstacle position can spawn an obstacle (if not then next phsyics process will do it again)
		
		var obstacle = obstacle_select.instantiate()
		
		if obstacle_select == mountain_scene:
			obstacles[obstacle] = obstacle_position.x
		else:
			obstacles[obstacle] = obstacle_position.y
				
		add_child(obstacle)
			
		obstacle.position.x = obstacle_position.x
		obstacle.position.y = obstacle_position.y
	
		var double = random.randi_range(1, 4)
	
		if double == 4:
			_spawn_obstacle()
	
		if global.difficulty == "Easy":
			await get_tree().create_timer(1).timeout
		elif global.difficulty == "Normal":
			await get_tree().create_timer(0.5).timeout
		elif global.difficulty == "Hard":
			await get_tree().create_timer(0.2).timeout		
			
		obstacles.erase(obstacle)
	
	obstacle_cool_down = false
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	global.obstacles_dodged = 0
	
	if global.difficulty == "Easy":
		$CanvasLayer.get_child(2).color = Color.DARK_GREEN
		$CanvasLayer.get_child(3).color = Color.GREEN
		$CanvasLayer.get_child(3).get_child(1).add_theme_color_override("font_color",
				 Color.FLORAL_WHITE)
	elif global.difficulty == "Normal":
		$CanvasLayer.get_child(2).color = Color.DARK_ORANGE
		$CanvasLayer.get_child(3).color = Color.ORANGE
		$CanvasLayer.get_child(3).get_child(1).add_theme_color_override("font_color",
			 	Color.PAPAYA_WHIP)
	if global.difficulty == "Hard":
		$CanvasLayer.get_child(2).color = Color.DARK_RED
		$CanvasLayer.get_child(3).color = Color.RED
		$CanvasLayer.get_child(3).get_child(1).add_theme_color_override("font_color",
		 		Color.LIGHT_YELLOW)


# Called every frame.'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Camera2D.position.x = $CharacterBody2D.position.x
	$Camera2D.position.y = clamp($CharacterBody2D.position.y, CAMERA_CLAMP_Y_MINIMUM,
			 CAMERA_CLAMP_Y_MAXIMUM)
	
	if $CharacterBody2D.position.x > TAKE_OFF_LEAVE_X: # If the player is past the take off point then obstacles can spawn
	
		if obstacle_cool_down == false:
			_spawn_obstacle()
			
	$CanvasLayer.get_child(4).text = "Obstacles Dodged:     " + str(global.obstacles_dodged)
	
	# Changing the distance covered bar
	$CanvasLayer.get_child(3).position.x = -$CanvasLayer.get_child(3).size.x * (
				1 - $CharacterBody2D.position.x / $Node2D3.position.x)
	$CanvasLayer.get_child(3).get_child(0).text = (str(floor($CharacterBody2D.position.x)) + " / "
			+ str($Node2D3.position.x))

