extends Control

var ButtonsHover = {}

func _play():
	get_tree().change_scene_to_file("res://scenes/TestingScene.tscn")

func _options():
	get_tree().change_scene_to_file("res://scenes/OptionsScreen.tscn")
	
func _playButtonPressed():
	_play()

func _optionsButtonPressed():
	_options()

func _buttonEffect(Button, Hover, Press):
	
	if Hover == true:
		print(Button)
		#ButtonsHover[Button] = Button.size
		#Button.size.x = Button.size.x + (Button.size.x / 4)
		#Button.size.x = Button.size.y + (Button.size.y / 4)
		
	elif Hover == false:
		
		Button.size = ButtonsHover[Button]
		ButtonsHover.erase(Button)
		
