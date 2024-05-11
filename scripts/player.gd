extends CharacterBody2D

@onready var Hurtbox := $Hurtbox
@onready var DodgeAnimation := $DodgeAnimation

@export var MAX_VELOCITY := 600.0
@export var MIN_VELOCITY := 20.0
@export var ACCELERATION := 8000.0
@export var STANDARD_FRICTION := 0.1

@export var DODGE_VELOCITY = 900.0
@export var DODGE_COOLDOWN = 0.4
@export var INVINCIBILE_TIME = 0.3

enum {
	MOVE,
	DODGE
}
var state = MOVE

var aimingNormalVector := Vector2.ZERO

var dodgeCoolDown = 0

func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("move_dodge") && dodgeCoolDown <= 0:
		state = DODGE
	elif dodgeCoolDown > 0:
		dodgeCoolDown -= delta

	match state:
		MOVE:
			_move(delta)
		DODGE:
			_dodge(delta)

	# apply movement
	move_and_slide()


func _move(delta: float):
	# inputs
	aimingNormalVector = get_global_mouse_position() - global_position
	aimingNormalVector = aimingNormalVector.normalized()
	var hmove = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var vmove = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	# calc movement
	velocity += Vector2(hmove * ACCELERATION, vmove * ACCELERATION) * delta
	velocity = velocity.limit_length(MAX_VELOCITY)

	# friction
	velocity = lerp(velocity, Vector2.ZERO, STANDARD_FRICTION)
	if velocity.length() < MIN_VELOCITY:
		velocity = Vector2.ZERO

func _dodge(delta):
	velocity = velocity.normalized() * DODGE_VELOCITY
	Hurtbox.start_invincibility(INVINCIBILE_TIME)
	DodgeAnimation.play("dodge", -1, 1/INVINCIBILE_TIME)

func _dodge_ended():
	state = MOVE
	dodgeCoolDown = DODGE_COOLDOWN
