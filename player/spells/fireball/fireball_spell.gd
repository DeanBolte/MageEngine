class_name FireBallSpell
extends Spell

@onready var BaseParticleEffect := $BaseParticleEffect
@onready var ExplosionParticleEffect := $ExplosionParticleEffect
@onready var ExplosionArea := $ExplosionArea

@export var BASE_VELOCITY := 50.0
@export var DECAY_TIME := 3.0
@export var BASE_DAMAGE := 2.0

var direction: Vector2
var decay_timer := DECAY_TIME
var _exploding: bool = false

func _ready():
	BaseParticleEffect.emitting = true

func _physics_process(delta: float) -> void:
	if not _exploding:
		_move()
		var collided := move_and_slide()

		# decay
		_decay(delta)
		if collided || decay_timer <= 0:
			kill()
	else:
		_death()

func _decay(delta: float) -> void:
	if decay_timer > 0:
		decay_timer -= delta

func _move() -> void:
	velocity = direction.normalized() * BASE_VELOCITY

func _death() -> void:
	if ExplosionParticleEffect and not ExplosionParticleEffect.is_emitting():
		queue_free()


func kill() -> void:
	_exploding = true
	BaseParticleEffect.emitting = false
	ExplosionParticleEffect.emitting = true
	ExplosionArea.activate()

func get_base_damage():
	return BASE_DAMAGE