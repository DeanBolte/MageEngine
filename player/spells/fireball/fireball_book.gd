class_name FireBallBook
extends Book

@onready var CollisionShape := $FireSpellHitBox/CollisionShape2D
@onready var BaseParticleEffect := $BaseParticleEffect
@onready var ActiveParticleEffect := $ActiveParticleEffect

@export var FIREBALL_SPAWN_SECONDS := 20.0
@export var FIREBALL_COOLDOWN_SECONDS := 2.0
@export var FIREBALL_SPAWN_DISTANCE := 30

var _fireball_cooldown := 0.0
var _fireball_spawn_timer := FIREBALL_SPAWN_SECONDS

func _ready() -> void:
	_spell_scene = preload("res://player/spells/fireball/fireball_spell.tscn")

func _process(delta: float) -> void:
	# fire throwing / summoning fireball
	CollisionShape.disabled = !_is_active || _fireball_cooldown > 0
	BaseParticleEffect.emitting = CollisionShape.disabled
	ActiveParticleEffect.emitting = _is_active && _fireball_cooldown <= 0

	if _fireball_cooldown <= 0:
		if _is_active:
			_fireball_spawn_timer -= delta
		else:
			# if spell stops being active before end of timer restart timer
			_fireball_spawn_timer = FIREBALL_SPAWN_SECONDS

		if _fireball_spawn_timer <= 0:
			# if spell key is released and timer is over spawn fireball
			_fireball_cooldown = FIREBALL_COOLDOWN_SECONDS
			_fireball_spawn_timer = FIREBALL_SPAWN_SECONDS
			_spawn()
	else:
		_fireball_cooldown -= delta



