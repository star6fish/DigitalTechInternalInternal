extends CharacterBody2D

@export var SPEED = 300.0

var TakingOff = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _hitobject(object):
	if object.get_parent().has_meta("obstacle"):
		queue_free()
		get_tree().reload_current_scene()

func _physics_process(delta):
	
	# Add the gravity.
	
	#if not is_on_floor():
		#velocity.y += gravity * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if TakingOff == true:
		
		if position.y >= 100:
			TakingOff = false
		else:
			velocity.x = SPEED
			velocity.y = SPEED
			rotation = rotate_toward(rotation, -0.8, delta)
			
	elif TakingOff == false:
		
		var direction_x = Input.get_axis("ui_left", "ui_right")
		var direction_y = Input.get_axis("ui_up", "ui_down")
		
		if direction_x:
			velocity.x = clamp(direction_x * SPEED, 0, SPEED)
		else:
			velocity.x = 0
			
		velocity.x += SPEED

		if direction_y:
			velocity.y = direction_y * (abs(direction_y + rotation) * SPEED)
			rotation = rotate_toward(rotation, 0.8 * direction_y, delta * 2.5)
		else:
			velocity.y = move_toward(velocity.y, 0 + rotation, SPEED)
			rotation = rotate_toward(rotation, 0, delta * 2.5)
			
		move_and_slide()
