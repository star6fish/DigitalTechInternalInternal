extends CharacterBody2D

@export var SPEED = 300.0
@export var ExplosionScene: PackedScene

var TakingOff = true
var Crashing = false

var Explosion = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _win():
	get_tree().change_scene_to_file("res://scenes/PlayScreen.tscn")

func _hitobject(object):
	if object.get_parent().has_meta("obstacle"):
		
		Crashing = true
		SPEED = 150
		
		Explosion = ExplosionScene.instantiate()
		
		Explosion.position.x = position.x
		Explosion.position.y = position.y
		
		Explosion.get_child(0).modulate = Color.ORANGE
		Explosion.get_child(1).color = Color.ORANGE
		
		get_parent().add_child(Explosion)
		
		await get_tree().create_timer(0.5).timeout
		
		queue_free()
		get_tree().paused = false
		get_tree().reload_current_scene()	
		
	elif object.get_parent().name == "Node2D3":
		_win()

func _physics_process(delta):
	
	$AnimatedSprite2D.play()
	
	# Add the gravity.
	
	#if not is_on_floor():
		#velocity.y += gravity * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if TakingOff == true:

		if position.y <= -85:
			rotation = rotate_toward(rotation, 0, delta * 0.2)
			if rotation == 0:
				TakingOff = false
		else:
			velocity.x = SPEED * 2
			velocity.y = 1 * (rotation * SPEED)
			
			if position.x >= - 215:
				rotation = rotate_toward(rotation, -0.5, delta)
			
	elif TakingOff == false:
		
		var direction_x = Input.get_axis("ui_left", "ui_right")
		var direction_y = Input.get_axis("ui_up", "ui_down")
		
		if direction_x:
			velocity.x = clamp(direction_x * SPEED, 0, SPEED)
		else:
			velocity.x = 0
			
		velocity.x += SPEED

		if Crashing == true:
			velocity.y = 200
			rotation = rotate_toward(rotation, 45, delta * 2)
		elif Crashing == false:
			if direction_y:
				rotation = rotate_toward(rotation, 0.8 * direction_y, delta * 4)
				#velocity.y = 1 * (abs(rotation) * SPEED)
			else:
				rotation = rotate_toward(rotation, 0, delta * 5)
				#velocity.y = clamp(round(velocity.y), -1, 1) * (abs(rotation) * SPEED)
				
			if position.y == -910 and not direction_y:
				rotation = rotate_toward(rotation, 0, delta * 5)
				
			velocity.y = 1 * (rotation * SPEED)
			
	move_and_slide()
	
	position.y = clamp(position.y, -910, 200)
	
	#if Crashing == true:
		#Explosion.position.x = position.x
		#Explosion.position.y = position.y
