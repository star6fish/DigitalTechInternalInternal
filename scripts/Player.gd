extends CharacterBody2D

@export var SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	
	# Add the gravity.
	
	#if not is_on_floor():
		#velocity.y += gravity * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	
	if direction_x:
		velocity.x = clamp(direction_x * SPEED, 0, SPEED)
	else:
		velocity.x = 0
		
	velocity.x += SPEED

	if direction_y:
		velocity.y = direction_y * (abs(0.8 * direction_y) * SPEED)
		rotation = rotate_toward(rotation, 0.8 * direction_y, delta * 2)
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		rotation = rotate_toward(rotation, 0, delta * 2)
		
	move_and_slide()
