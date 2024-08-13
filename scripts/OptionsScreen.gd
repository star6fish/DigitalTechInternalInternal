extends Control

@onready var global = get_node("res://scripts/global.gd")

func _grey():
	global.ColourPlane = Color.GRAY
	
func _green():
		global.ColourPlane = Color.GREEN
	
func _blue():
		global.ColourPlane = Color.BLUE

func  _orange():
		global.ColourPlane = Color.ORANGE

func _back():
	get_tree().change_scene_to_file("res://scenes/PlayScreen.tscn")

func _backButtonPressed():
	_back()
