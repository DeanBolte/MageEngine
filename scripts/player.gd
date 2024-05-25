extends CharacterBody2D

@onready var Hurtbox := $Hurtbox
@onready var DodgeAnimation := $DodgeAnimation

@onready var FireSpell := $FireSpellHitBox

@export var MAX_VELOCITY := 600.0
@export var SPELL_MAX_VELOCITY := 300.0
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

var _current_max_velocity := MAX_VELOCITY
var _aiming_normal_vector := Vector2.ZERO

var _dodge_cooldown = 0

var _primary_spell

func _ready() -> void:
	_primary_spell = FireSpell

func _physics_process(delta: float) -> void:


	if Input.is_action_just_pressed("move_dodge") && _dodge_cooldown <= 0:
		state = DODGE
	elif _dodge_cooldown > 0:
		_dodge_cooldown -= delta

	match state:
		MOVE:
			_move(delta)
		DODGE:
			_dodge(delta)

	_spells(delta)

	# apply movement
	move_and_slide()

func _spells(_delta: float):
	# priamry spell active
	var primary_spell_input = Input.is_action_pressed("spell_primary")

	if primary_spell_input and !_primary_spell.is_spell_active():
		_primary_spell.set_spell_active(true)
		_current_max_velocity = SPELL_MAX_VELOCITY
	if !primary_spell_input and _primary_spell.is_spell_active():
		_primary_spell.set_spell_active(false)
		_current_max_velocity = MAX_VELOCITY

func _move(delta: float):
	# inputs
	_aiming_normal_vector = get_global_mouse_position() - global_position
	_aiming_normal_vector = _aiming_normal_vector.normalized()
	var hmove = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var vmove = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	# calc movement
	velocity += Vector2(hmove * ACCELERATION, vmove * ACCELERATION) * delta
	velocity = velocity.limit_length(_current_max_velocity)

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
	_dodge_cooldown = DODGE_COOLDOWN
