extends RayCast3D


func deal_damage() -> void:
	if not is_colliding():
		return
	var collider = get_collider()
	
	if collider is Enemy:
		collider.health_component.take_damage(15.0)
		# makes option no longer collide with the node (raycast does not collide with same node in a single swing)
		add_exception(collider)
