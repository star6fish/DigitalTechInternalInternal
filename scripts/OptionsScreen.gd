extends Control

func _back():
	get_tree().change_scene_to_file("res://scenes/PlayScreen.tscn")

func _backButtonPressed():
	_back()
