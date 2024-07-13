extends Node2D

const GrassEffect = preload("res://Effects/grass_effect.tscn")

func create_grass_effect():
		var grassEffect = GrassEffect.instantiate()
		get_parent().add_child(grassEffect)
		grassEffect.global_position = global_position #we asign the global position of the grassEffect to the global position of the current node, grass

func _on_hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
