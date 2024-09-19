extends Control

@onready var global = get_node("/root/Global")

var ButtonsHover = {}

func _grey():
	global.ColourPlane = Color.GRAY
	
func _green():
	global.ColourPlane = Color.GREEN
	
func _blue():
	global.ColourPlane = Color.DARK_TURQUOISE

func  _orange():
	global.ColourPlane = Color.ORANGE

func _easy():
	global.Difficulty = "Easy"
	
func _normal():
	global.Difficulty = "Normal"

func _hard():
	global.Difficulty = "Hard"

func _back():
	get_tree().change_scene_to_file("res://scenes/PlayScreen.tscn")

func _backButtonPressed():
	_back()

func _buttonEffect(ButtonTarget, Hover, Press):
	
	if Hover == true:
		
		if not ButtonsHover.get(ButtonTarget):
			
			ButtonsHover[ButtonTarget] = ButtonTarget.scale
			
			var ButtonTween = create_tween()
			ButtonTween.tween_property(ButtonTarget, "scale", ButtonTarget.scale + (ButtonTarget.scale / 6), 0.1)
			
	elif Hover == false:
		
		if ButtonsHover.get(ButtonTarget):
			
			var ButtonTween = create_tween()
			ButtonTween.tween_property(ButtonTarget, "scale", ButtonsHover[ButtonTarget], 0.1)
			
			ButtonsHover.erase(ButtonTarget)
			
	if Press == true:
			
		var ButtonTween = create_tween()
		ButtonTween.tween_property(ButtonTarget, "scale", ButtonsHover[ButtonTarget] - (ButtonsHover[ButtonTarget] / 6), 0.1)
		
	elif Press == false:
		
		if Hover == true:
			
			if ButtonsHover.get(ButtonTarget):
				
				var ButtonTween = create_tween()
				ButtonTween.tween_property(ButtonTarget, "scale", ButtonsHover[ButtonTarget] + (ButtonsHover[ButtonTarget] / 6), 0.1)
		
func _process(delta):
	
	for i in get_children():
		if i.has_signal("button_down"):
			
			if i.is_hovered() == true:
				_buttonEffect(i, true, false)
			elif i.is_hovered() == false:
				_buttonEffect(i, false, false)
				
			if i.is_pressed() == true:
				_buttonEffect(i, true, true)
			if i.is_pressed() == false:
				if i.is_hovered() == true:
					_buttonEffect(i, true, false)
