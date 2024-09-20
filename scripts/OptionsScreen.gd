extends Control

@onready var global = get_node("/root/Global")

var ButtonsHover = {}

func updateButtonOutlines():
	
	for i in $CanvasLayer2.get_children():
		if i.has_signal("button_down"):
			if Color.from_string(i.name, Color.BLACK) == global.ColourPlane:
				$CanvasLayer2/ColourSelect.position = i.position
		
	for i in $CanvasLayer2.get_children():
		if i.has_signal("button_down"):
			if i.name == global.Difficulty:
				$CanvasLayer2/DifficultySelect.position = i.position

func _grey():
	global.ColourPlane = Color.GRAY
	updateButtonOutlines()
	
func _green():
	global.ColourPlane = Color.GREEN
	updateButtonOutlines()
	
func _blue():
	global.ColourPlane = Color.DARK_TURQUOISE
	updateButtonOutlines()

func  _orange():
	global.ColourPlane = Color.ORANGE
	updateButtonOutlines()

func _easy():
	global.Difficulty = "Easy"
	updateButtonOutlines()
	
func _normal():
	global.Difficulty = "Normal"
	updateButtonOutlines()

func _hard():
	global.Difficulty = "Hard"
	updateButtonOutlines()

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
		
func _ready():
	updateButtonOutlines()
		
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
