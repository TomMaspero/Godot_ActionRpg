extends AnimatedSprite2D

func _ready():
	self.animation_finished.connect(on_animation_finished);
	play("Animate");

func on_animation_finished():
	queue_free();
