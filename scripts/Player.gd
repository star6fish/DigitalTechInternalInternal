extends CharacterBody2D

@export var speed = 400.0
@export var explosion_scene: PackedScene
@export var bullet_scene: PackedScene

@onready var global = get_node("/root/Global")

var taking_off = true
var crashing = false

const VELOCITY_CLAMP_MINIMUM_Y = -910
const VELOCITY_CLAMP_MAXIMUM_Y = 200

var explosion = false
var shake_strength = 0.0
const EXPLOSION_ZOOM = 1.5
const SHAKE_MAGNITUDE = 40.0
const SHAKE_OFFSET = 400

var shooting_cooldown = false

const TAKE_OFF_ROTATION_MINIMISED = -0.5

const TAKE_OFF_ROTATION = -215
const TAKE_OFF_LEVEL_Y = -85

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _win():
	get_tree().change_scene_to_file("res://scenes/WinScreen.tscn")


# Jet plane hit an object
func _hit_object(object):
	if object.get_parent().has_meta("obstacle"):
		
		crashing = true
		speed = 150
		
		explosion = explosion_scene.instantiate()
		
		explosion.position.x = position.x
		explosion.position.y = position.y
		explosion.get_child(0).modulate = Color.ORANGE
		explosion.get_child(1).color = Color.ORANGE
		
		get_parent().add_child(explosion)
		
		await get_tree().create_timer(0.5).timeout
		
		if get_tree() != null:
			get_tree().paused = false
			queue_free()
			global.map_type = "Ocean"
			get_tree().reload_current_scene()	
			
	elif object.has_meta("MapType"):
		global.map_type = object.get_meta("MapType")
	elif object.get_parent().name == "Node2D3":
		_win()


# Obstacle detector hit an object
func _hit_object_obstacle_detector(object):
	if object.get_parent().name != "Node2D" and object.get_parent().has_meta("obstacle"):
		global.obstacles_dodged += 1


# Shoot a bullet
func _shoot():
	
	shooting_cooldown = true
	
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	
	bullet.position = position
	bullet.rotation = rotation
	
	await get_tree().create_timer(0.5).timeout
	
	shooting_cooldown = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.modulate = global.colour_plane
	
	if taking_off == true:

		$AnimatedSprite2D.animation = "default"

		if position.y <= TAKE_OFF_LEVEL_Y: # If player is taking off
			rotation = rotate_toward(rotation, 0, delta * 0.2)
			if rotation == 0: # If player has finished taking off then switch taking_off to false
				taking_off = false
		else:
			velocity.x = speed * 2
			velocity.y = 1 * (rotation * speed)
			
			if position.x >= TAKE_OFF_ROTATION:
				rotation = rotate_toward(rotation, TAKE_OFF_ROTATION_MINIMISED, delta)
			
	elif taking_off == false:
		
		var direction_x = Input.get_axis("ui_left", "ui_right")
		var direction_y = Input.get_axis("ui_up", "ui_down")
		
		if direction_x:
			velocity.x = clamp(direction_x * speed, 0, speed)
			$AnimatedSprite2D.animation = "default_speeding"
		else:
			velocity.x = 0
			$AnimatedSprite2D.animation = "default"
			
		velocity.x += speed

		if crashing == true:
			
			velocity.y = 200
			rotation += 5 * delta
			
			$AnimatedSprite2D.animation = "default"
			
			# Shake the camera when the player is crashing
			shake_strength = lerp(shake_strength, SHAKE_MAGNITUDE, 5 * delta)
		
			var shake_vector = Vector2(SHAKE_OFFSET - (
			 		SHAKE_OFFSET * (shake_strength / SHAKE_MAGNITUDE) / 4)
				 	+ RandomNumberGenerator.new().randf_range(-shake_strength, shake_strength),
				 	RandomNumberGenerator.new().randf_range(-shake_strength, shake_strength))
			
			get_parent().get_child(9).offset = lerp(get_parent().get_child(9).offset, shake_vector,
			 		delta * 10)
			
			get_parent().get_child(9).rotation = lerp(get_parent().get_child(9).rotation,
				 	RandomNumberGenerator.new().randf_range(-shake_strength, shake_strength),
				 	delta * 5)
			
			get_parent().get_child(9).zoom = lerp(get_parent().get_child(9).zoom,
					 Vector2(EXPLOSION_ZOOM, EXPLOSION_ZOOM), delta)
			
		elif crashing == false:
			if direction_y:
				rotation = rotate_toward(rotation, 0.8 * direction_y, delta * 4)
			else:
				rotation = rotate_toward(rotation, 0, delta * 5)
				
			if position.y == -910 and not direction_y:
				rotation = rotate_toward(rotation, 0, delta * 5)
				
			velocity.y = 1 * (rotation * speed)
			
			var shooting = Input.is_action_pressed("shoot")
			
			if shooting and shooting_cooldown == false:
				_shoot()
			
	move_and_slide()
	
	position.y = clamp(position.y, VELOCITY_CLAMP_MINIMUM_Y, VELOCITY_CLAMP_MAXIMUM_Y) # Stop the player from going too high or too low
	
	#if Crashing == true:
		#Explosion.position.x = position.x
		#Explosion.position.y = position.y
		
