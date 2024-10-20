extends Control

@onready var global = get_node("/root/Global")

var buttons_hover = {}


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


func _button_effect(button_target, hover, press):
	
	if hover == true:
		
		if not buttons_hover.get(button_target):
			
			buttons_hover[button_target] = button_target.scale
			
			var button_tween = create_tween()
			button_tween.tween_property(button_target, "scale", button_target.scale
					 + (button_target.scale / 6), 0.1)
			
	elif hover == false:
		
		if buttons_hover.get(button_target):
			
			var button_tween = create_tween()
			button_tween.tween_property(button_target, "scale", buttons_hover[button_target], 0.1)
			
			buttons_hover.erase(button_target)
			
	if press == true:
			
		var button_tween = create_tween()
		button_tween.tween_property(button_target, "scale", buttons_hover[button_target]
				 - (buttons_hover[button_target] / 6), 0.1)
		
	elif press == false:
		
		if hover == true:
			
			if buttons_hover.get(button_target):
				
				var button_tween = create_tween()
				button_tween.tween_property(button_target, "scale", buttons_hover[button_target]
						 + (buttons_hover[button_target] / 6), 0.1)

# Called when the node enters the scene tree for the first time.
func _ready():
	update_button_outlines()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	for i in get_children():
		if i.has_signal("button_down"):
			
			if i.is_hovered() == true:
				_button_effect(i, true, false)
			elif i.is_hovered() == false:
				_button_effect(i, false, false)
				
			if i.is_pressed() == true:
				_button_effect(i, true, true)
			if i.is_pressed() == false:
				if i.is_hovered() == true:
					_button_effect(i, true, false)

