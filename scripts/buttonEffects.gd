extends CanvasLayer

var ButtonsHover = {}

const BUTTON_TWEENING_SIZE_SPEED = 0.1

func _buttonEffect(ButtonTarget, Hover, Press):
	
	if Hover == true:
		
		if not ButtonsHover.get(ButtonTarget):
			
			ButtonsHover[ButtonTarget] = ButtonTarget.scale
			
			var ButtonTween = create_tween()
			ButtonTween.tween_property(ButtonTarget, "scale", ButtonTarget.scale
					 + (ButtonTarget.scale / 6), BUTTON_TWEENING_SIZE_SPEED)
			
	elif Hover == false:
		
		if ButtonsHover.get(ButtonTarget):
			
			var ButtonTween = create_tween()
			ButtonTween.tween_property(ButtonTarget, "scale", ButtonsHover[ButtonTarget],
					 BUTTON_TWEENING_SIZE_SPEED)
			
			ButtonsHover.erase(ButtonTarget)
			
	if Press == true:
			
		var ButtonTween = create_tween()
		ButtonTween.tween_property(ButtonTarget, "scale", ButtonsHover[ButtonTarget]
				 - (ButtonsHover[ButtonTarget] / 6), BUTTON_TWEENING_SIZE_SPEED)
		
	elif Press == false:
		
		if Hover == true:
			
			if ButtonsHover.get(ButtonTarget):
				
				var ButtonTween = create_tween()
				ButtonTween.tween_property(ButtonTarget, "scale", ButtonsHover[ButtonTarget]
						 + (ButtonsHover[ButtonTarget] / 6), BUTTON_TWEENING_SIZE_SPEED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
