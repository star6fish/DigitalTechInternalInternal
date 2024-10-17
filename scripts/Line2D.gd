extends Line2D

var TrailPoint_Queue = []
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	TrailPoint_Queue.push_front(get_parent().position)
	
	if TrailPoint_Queue.size() > 2000:
		TrailPoint_Queue.pop_back()
		
	clear_points()
	
	for point in TrailPoint_Queue:
		add_point(point)
