extends Area2D

const HitEffect = preload("res://Effects/hit_effect.tscn")

var invincible = false:
	get = get_invincible, set = set_invincible;
	
@onready var timer = $Timer
	
signal invincibility_started
signal invincibility_ended

func get_invincible():
	return invincible;

func set_invincible(value):
	invincible = value;
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		
func start_invincibility(duration):
	set_invincible(true)
	timer.start(duration);
	
func create_hit_effect():
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_timer_timeout():
	set_invincible(false)

func _on_invincibility_started():
	set_deferred("monitoring", false)

func _on_invincibility_ended():
	monitoring = true
