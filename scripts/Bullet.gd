extends Area2D

@onready var global = get_node("/root/Global")

var ObjectsHit = 0

func _hitobject(object):
	if object.get_parent().has_meta("obstacle"):
		ObjectsHit += 1
		if ObjectsHit >= 5:
			queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += 2000 * delta
	position.y += delta * (rotation * 500)
