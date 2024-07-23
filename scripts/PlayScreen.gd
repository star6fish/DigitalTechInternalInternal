extends Control

func _play():
	get_tree().change_scene_to_file("res://scenes/TestingScene.tscn")

func _options():
	get_tree().change_scene_to_file("res://scenes/OptionsScreen.tscn")
	
func _playButtonPressed():
	_play()

func _optionsButtonPressed():
	_options()
