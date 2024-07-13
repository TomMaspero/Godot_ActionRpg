###################################################################
# This is meantReusable Scene for different enemies
# 
####################################################################
extends Area2D

var player = null

func can_see_player():
	return player != null 

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	player = body


func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	player = null
