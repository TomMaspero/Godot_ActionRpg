extends CharacterBody2D

const KNOCKBACKDISTANCE = 130;
const SOFTCOLLISIONAMPLITUDE = 400;
const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn") 

enum {
	IDLE,
	WANDER,
	CHASE
}

@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var sprite = $AnimatedSprite
@onready var hurtbox = $Hurtbox
@onready var softCollision = $SoftCollision

@export var ACCELERATION = 300
@export var MAX_SPEED = 40
@export var FRICTION = 200

const DIRECTION_OFFSET = 1.75

var knockback = Vector2.ZERO
var state = CHASE

func _ready():
	pass

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta);
	if knockback != Vector2.ZERO:
		velocity.x = move_toward(knockback.x, 0, delta);
		velocity.y = move_toward(knockback.y, 0, delta); 
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()*DIRECTION_OFFSET
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION*delta)
				sprite.flip_h = velocity.x < 0
			else:
				state = IDLE
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * SOFTCOLLISIONAMPLITUDE;
	move_and_slide()
	
func _on_hurtbox_area_entered(area):
	stats.health -= area.damage # this is actually calling the set function
	var direction = (position - area.owner.position).normalized()
	knockback = direction * KNOCKBACKDISTANCE
	hurtbox.create_hit_effect();
	

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_stats_no_health():
	queue_free();
	var enemyDeathEffect = EnemyDeathEffect.instantiate();
	get_parent().add_child(enemyDeathEffect);
	enemyDeathEffect.global_position = global_position;
