extends Area2D

@onready var CollisionShape := $CollisionShape2D
@onready var BaseParticleEffect := $BaseParticleEffect
@onready var ActiveParticleEffect := $ActiveParticleEffect

@export var FIREBALL_SPAWN_SECONDS := 2.0
@export var FIREBALL_COOLDOWN_SECONDS := 2.0
@export var FIREBALL_SPAWN_DISTANCE := 30

var FireballScene := preload("res://scenes/player/fireball.tscn")

var _fireball_cooldown := 0.0
var _fireball_spawn_timer := FIREBALL_SPAWN_SECONDS

var _aim_direction: Vector2
var _is_spell_active: bool = false :
	set = set_spell_active

func _unhandled_input(event: InputEvent) -> void:
	var mouse_motion = event as InputEventMouseMotion

	if mouse_motion:
		_aim_direction = (mouse_motion.global_position - global_position).normalized()
		rotation = _aim_direction.angle() + PI/2

func _process(delta: float) -> void:
	# fire throwing / summoning fireball
	CollisionShape.disabled = !_is_spell_active || _fireball_cooldown > 0
	BaseParticleEffect.emitting = CollisionShape.disabled
	ActiveParticleEffect.emitting = _is_spell_active && _fireball_cooldown <= 0

	if _fireball_cooldown <= 0:
		if _is_spell_active:
			_fireball_spawn_timer -= delta
		else:
			# if spell stops being active before end of timer restart timer
			_fireball_spawn_timer = FIREBALL_SPAWN_SECONDS

		if _fireball_spawn_timer <= 0:
			# if spell key is released and timer is over spawn fireball
			_fireball_cooldown = FIREBALL_COOLDOWN_SECONDS
			_fireball_spawn_timer = FIREBALL_SPAWN_SECONDS
			_spawn_fireball()
	else:
		_fireball_cooldown -= delta


func _spawn_fireball():
	var fireball: FireballSpell = FireballScene.instantiate()
	fireball.global_position = global_position + _aim_direction * FIREBALL_SPAWN_DISTANCE
	fireball.direction = _aim_direction
	get_parent().get_parent().add_child(fireball)

func set_spell_active(activated: bool) -> void:
	_is_spell_active = activated
	print(activated)

func is_spell_active() -> bool:
	return _is_spell_active
