extends Area2D

#Detects whether this is overlapping something and returns a "push" vector

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = areas[0] #we take the first one and ignore the others
		push_vector = area.global_position.direction_to(global_position).normalized()
	return push_vector
