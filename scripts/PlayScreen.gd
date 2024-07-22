extends Control

func _play():
	get_tree().change_scene_to_file("res://scenes/TestingScene.tscn")
	
func _playButtonPressed(button):
	if button == KEY_SPACE:
		_play()
