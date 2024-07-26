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
@onready var wanderController = $WanderController
@onready var animationPlayer = $AnimationPlayer

@export var ACCELERATION = 300
@export var MAX_SPEED = 60
@export var FRICTION = 200
@export var WANDER_TOLERANCE = 4

var knockback = Vector2.ZERO
var state = pick_random_state([IDLE, WANDER, CHASE]);

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta);
	if knockback != Vector2.ZERO:
		velocity.x = move_toward(knockback.x, 0, delta);
		velocity.y = move_toward(knockback.y, 0, delta); 
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
			if wanderController.get_time_left() == 0:
				update_wander();
			seek_player();
		WANDER:
			if wanderController.get_time_left() == 0:
				update_wander();
			accelerate_towards(wanderController.target_position, delta);
			if global_position.distance_to(wanderController.target_position) <= WANDER_TOLERANCE:
				update_wander();
			seek_player();
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards(player.global_position, delta);
			else:
				update_wander();
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * SOFTCOLLISIONAMPLITUDE;
	move_and_slide()
	
func accelerate_towards(point, delta):
	var direction = global_position.direction_to(point);
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta);
	sprite.flip_h = velocity.x < 0;

func update_wander():
	state = pick_random_state([IDLE, WANDER]);
	if state == WANDER:
		wanderController.start_wander_timer(randi_range(1,3));

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage # this is actually calling the set function
	var direction = (position - area.owner.position).normalized()
	knockback = direction * KNOCKBACKDISTANCE
	hurtbox.create_hit_effect();
	hurtbox.start_invincibility(0.4);

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front();

func _on_stats_no_health():
	queue_free();
	var enemyDeathEffect = EnemyDeathEffect.instantiate();
	get_parent().add_child(enemyDeathEffect);
	enemyDeathEffect.global_position = global_position;

func _on_hurtbox_invincibility_started():
	animationPlayer.play("Start");

func _on_hurtbox_invincibility_ended():
	animationPlayer.play("Stop");
