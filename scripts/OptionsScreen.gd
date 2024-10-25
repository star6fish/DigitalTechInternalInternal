extends Control

@onready var global = get_node("/root/Global")

var buttons_hovering = {}

const BUTTON_TWEENING_SIZE_SPEED = 0.1


func update_button_outlines():
	
	for i in $CanvasLayer2.get_children():
		if i.has_signal("button_down"):
			if Color.from_string(i.name, Color.BLACK) == global.colour_plane:
				$CanvasLayer2/ColourSelect.position = i.position
		
	for i in $CanvasLayer2.get_children():
		if i.has_signal("button_down"):
			if i.name == global.difficulty:
				$CanvasLayer2/DifficultySelect.position = i.position


func _grey():
	global.colour_plane = Color.GRAY
	update_button_outlines()
	
	
func _green():
	global.colour_plane = Color.GREEN
	update_button_outlines()
	
	
func _blue():
	global.colour_plane = Color.DARK_TURQUOISE
	update_button_outlines()


func  _orange():
	global.colour_plane = Color.ORANGE
	update_button_outlines()


func _easy():
	global.difficulty = "Easy"
	update_button_outlines()

	
func _normal():
	global.difficulty = "Normal"
	update_button_outlines()


func _hard():
	global.difficulty = "Hard"
	update_button_outlines()


func _back():
	get_tree().change_scene_to_file("res://scenes/PlayScreen.tscn")


func _back_button_pressed():
	_back()


func _button_effect(button_target, hovering, pressing):
	
	if hovering == true:
		
		if not buttons_hovering.get(button_target):
			
			buttons_hovering[button_target] = button_target.scale
			
			var button_size_tween = create_tween()
			button_size_tween.tween_property(button_target, "scale", button_target.scale
					 + (button_target.scale / 6), BUTTON_TWEENING_SIZE_SPEED)
			
	elif hovering == false:
		
		if buttons_hovering.get(button_target):
			
			var button_size_tween = create_tween()
			button_size_tween.tween_property(button_target, "scale",
					 buttons_hovering[button_target], BUTTON_TWEENING_SIZE_SPEED)
			
			buttons_hovering.erase(button_target)
			
	if pressing == true:
			
		var button_size_tween = create_tween()
		button_size_tween.tween_property(button_target, "scale", buttons_hovering[button_target]
				 - (buttons_hovering[button_target] / 6), BUTTON_TWEENING_SIZE_SPEED)
		
	elif pressing == false:
		
		if hovering == true:
			
			if buttons_hovering.get(button_target):
				
				var button_size_tween = create_tween()
				button_size_tween.tween_property(button_target, "scale", buttons_hovering[button_target]
						 + (buttons_hovering[button_target] / 6), BUTTON_TWEENING_SIZE_SPEED)


# Called when the node enters the scene tree for the first time.
func _ready():
	update_button_outlines()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	for i in get_children():
		if i.has_signal("button_down"):
			
			_button_effect(i, i.is_hovered(), i.is_pressed())

