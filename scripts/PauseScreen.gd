extends Control

func _resume():
	get_tree().change_scene_to_file("res://scenes/TestingScene.tscn")

func _home():
	get_tree().change_scene_to_file("res://scenes/PlayScreen.tscn")
	
func _resumeButtonPressed():
	_resume()

func _homeButtonPressed():
	_home()
