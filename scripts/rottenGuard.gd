extends CharacterBody2D

@onready var PlayerDetectionZone: Area2D = $PlayerDetectionZone
@onready var PlayerLungeZone: Area2D = $PlayerLungeZone
@onready var Agent: NavigationAgent2D = $NavigationAgent2D
@onready var WanderController = $WanderController
@onready var LungeTimer: Timer = $PlayerLungeZone/LungeTimer

@export var MAX_VELOCITY := 100.0
@export var MIN_VELOCITY := 20.0
@export var ACCELERATION := 750.0
@export var STANDARD_FRICTION := 0.1

@export var MAX_HEALTH = 4
@export var STUN_DELAY = 0.2
@export var BASE_KNOCKBACK := 200.0

@export var LUNGE_VELOCITY := 400.0
@export var LUNGE_DELAY := 2.0
@export var LUNGE_PHASE2_SCALAR = 0.5
@export var LUNGE_PHASE2_DELAY := 0.25

class States:
	enum {
		IDLE,
		WANDER,
		STUNNED,
		LUNGING,
		CHASE,
		DEAD
	}

var state = States.IDLE

var stunned_timer: float = 0.0
var health = MAX_HEALTH
var _is_taking_damage: bool = false

func _physics_process(delta: float) -> void:
	if health <= 0:
		state = States.DEAD

	match state:
		States.IDLE:
			_idle(delta)
		States.WANDER:
			_wander(delta)
		States.LUNGING:
			_lunge(delta)
		States.STUNNED:
			_stunned(delta)
		States.CHASE:
			_chase_player(delta)
		States.DEAD:
			_death()

	move_and_slide()

# --- States ---
# IDLE
func _idle(delta: float) -> void:
	# check zone for player
	_seek_player()

	velocity = Vector2.ZERO

	if(WanderController.get_time_left() == 0):
		_update_wander()

# a generic player seeking function
func _seek_player() -> void:
	if PlayerDetectionZone.can_see_player():
		var vector_to_player = PlayerDetectionZone.player.global_position - global_position
		if not test_move(global_transform, vector_to_player):
			state = States.CHASE
			Agent.set_target_position(PlayerDetectionZone.player.global_position)

# WANDER
func _wander(delta: float) -> void:
	# check zone for player
	_seek_player()

	if(WanderController.get_time_left() == 0):
		_update_wander()

	_accelerate_towards_point(WanderController.target_position, MAX_VELOCITY, ACCELERATION * delta)

func _update_wander() -> void:
	state = _pick_rand_state([States.IDLE, States.WANDER])
	WanderController.start_wander_timer(randf_range(0, 1))

# LUNGE
func _lunge(delta: float) -> void:
	var player = PlayerLungeZone.player

	if player and not LungeTimer.is_stopped():
		var player_position = player.global_position
		var direction = global_position.direction_to(player_position)
		if global_position.distance_to(player_position) < 60:
			state = States.CHASE

		var lunge_vector = direction * LUNGE_VELOCITY
		# Lunge phase 2
		if LungeTimer.time_left <= LUNGE_PHASE2_DELAY:
			lunge_vector *= LUNGE_PHASE2_SCALAR

		velocity = velocity.move_toward(lunge_vector, ACCELERATION)
	else:
		state = States.CHASE

# STUNNED
func _stunned(delta: float) -> void:
	# slow down
	velocity = velocity.move_toward(Vector2.ZERO, 1)

	# stunned timer
	if stunned_timer > 0:
		stunned_timer -= delta
	else:
		state = States.IDLE

# CHASE
func _chase_player(_delta: float) -> void:
	var player = PlayerDetectionZone.player
	if player:
		# get close to player
		Agent.set_target_position(player.position)
		var direction = global_position.direction_to(Agent.get_next_path_position())
		velocity = velocity.move_toward(direction * MAX_VELOCITY, ACCELERATION)
	else:
		state = States.IDLE

# --- Utiliy Functions ---
func _accelerate_towards_point(point: Vector2, speed: float, acceleration: float) -> void:
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * speed, acceleration)

func _pick_rand_state(state_list: Array ):
	state_list.shuffle()
	return state_list.pop_front()

func _death() -> void:
	# slow down
	velocity = velocity.move_toward(Vector2.ZERO, STANDARD_FRICTION * 0.05)

	# delete enemy instance
	queue_free()


func lunge_at() -> void:
	state = States.LUNGING

func take_hit(damage: float, direction: Vector2) -> void:
	health -= damage
	velocity += direction.normalized() * BASE_KNOCKBACK
	stunned_timer = STUN_DELAY
	state = States.STUNNED

