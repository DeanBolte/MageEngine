class_name FireBallBook
extends Book

@onready var collisionShape := $FireSpellHitBox/CollisionShape2D
@onready var baseParticleEffect := $BaseParticleEffect
@onready var activeParticleEffect := $ActiveParticleEffect

@export var FIREBALL_SPAWN_SECONDS := 2.0
@export var FIREBALL_COOLDOWN_SECONDS := 2.0
@export var FIREBALL_SPAWN_DISTANCE := 30

func _ready() -> void:
	_spell_scene = preload("res://player/spells/fireball/fireball_spell.tscn")

	_chant_timer = FIREBALL_SPAWN_SECONDS

func _physics_process(delta: float) -> void:
	collisionShape.disabled = !_is_chanting
	baseParticleEffect.emitting = !_is_chanting
	activeParticleEffect.emitting = _is_chanting

func _chanting(delta: float) -> void:
	# spell no longer active
	if !_is_active:
		# if spell stops being active before end of timer restart timer
		_chant_timer = FIREBALL_SPAWN_SECONDS
	else:
		# spell is active
		_chant_timer -= delta

func _casting(delta: float) -> void:
	cooldownTimer.start(FIREBALL_COOLDOWN_SECONDS)
	_chant_timer = FIREBALL_SPAWN_SECONDS
	_spawn()

