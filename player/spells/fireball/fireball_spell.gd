class_name FireBallSpell
extends Spell

@onready var baseParticleEffect := $BaseParticleEffect
@onready var explosionParticleEffect := $ExplosionParticleEffect
@onready var explosionArea := $ExplosionArea
@onready var decayTimer: Timer = $DecayTimer

@export var BASE_VELOCITY := 50.0
@export var DECAY_TIME := 3.0

var direction: Vector2
var _exploding: bool = false

func _ready():
	BASE_DAMAGE = 2

	decayTimer.start(DECAY_TIME)
	baseParticleEffect.emitting = true

func _physics_process(delta: float) -> void:
	if not _exploding:
		_move()
		var collided := move_and_slide()

		if collided || decayTimer.is_stopped():
			kill()
	else:
		_death()

func _move() -> void:
	velocity = direction.normalized() * BASE_VELOCITY

func _death() -> void:
	if explosionParticleEffect and not explosionParticleEffect.is_emitting():
		queue_free()


func kill() -> void:
	_exploding = true
	baseParticleEffect.emitting = false
	explosionParticleEffect.emitting = true
	explosionArea.activate()


