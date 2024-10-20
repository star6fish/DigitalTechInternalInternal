extends Control


func _play():	
	get_tree().change_scene_to_file("res://scenes/TestingScene.tscn")


func _options():
	get_tree().change_scene_to_file("res://scenes/OptionsScreen.tscn")
	
	
func _play_button_pressed():
	_play()


func _options_button_pressed():
	_options()

