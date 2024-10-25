extends CanvasLayer

var buttons_hovering = {}

const BUTTON_TWEENING_SIZE_SPEED = 0.1


# Makes the button pressing size effect
func _button_effect(button_target, hovering, pressing):
	
	if hovering == true: # Bigger
		
		if not buttons_hovering.get(button_target):
			
			buttons_hovering[button_target] = button_target.scale
			
			var button_size_tween = create_tween()
			button_size_tween.tween_property(button_target, "scale", button_target.scale
					 + (button_target.scale / 6), BUTTON_TWEENING_SIZE_SPEED)
			
	elif hovering == false: # Normal
		
		if buttons_hovering.get(button_target):
			
			var button_size_tween = create_tween()
			button_size_tween.tween_property(button_target, "scale",
					 buttons_hovering[button_target], BUTTON_TWEENING_SIZE_SPEED)
			
			buttons_hovering.erase(button_target)
			
	if pressing == true: # Smaller
			
		var button_size_tween = create_tween()
		button_size_tween.tween_property(button_target, "scale", buttons_hovering[button_target]
				 - (buttons_hovering[button_target] / 6), BUTTON_TWEENING_SIZE_SPEED)
		
	elif pressing == false: 
		
		if hovering == true:# Bigger
			
			if buttons_hovering.get(button_target):
				
				var button_size_tween = create_tween()
				button_size_tween.tween_property(button_target, "scale", buttons_hovering[button_target]
						 + (buttons_hovering[button_target] / 6), BUTTON_TWEENING_SIZE_SPEED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in get_children():
		if i.has_signal("button_down"):
			
			_button_effect(i, i.is_hovered(), i.is_pressed())
