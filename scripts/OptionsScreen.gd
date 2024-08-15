extends Control

@onready var global = get_node("/root/Global")

func _grey():
	global.ColourPlane = Color.GRAY
	
func _green():
	global.ColourPlane = Color.GREEN
	
func _blue():
	global.ColourPlane = Color.DARK_TURQUOISE

func  _orange():
	global.ColourPlane = Color.ORANGE

func _easy():
	global.Difficulty = "Easy"
	
func _normal():
	global.Difficulty = "Normal"

func _hard():
	global.Difficulty = "Hard"

func _back():
	get_tree().change_scene_to_file("res://scenes/PlayScreen.tscn")

func _backButtonPressed():
	_back()
