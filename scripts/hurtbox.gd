extends Area2D

@export var Player: CharacterBody2D
@export var INVULNERABILITY_SECONDS: float = 0.5
@export var BASE_DAMAGE: float = 10
@export var BASE_KNOCKBACK: float = 300.0

@onready var InvincibleTimer = $Timer
@onready var CollisionShape = $CollisionShape2D

var _is_taking_damage: bool = false
var _damage_area: Node


func _process(delta: float) -> void:
	if _damage_area && _is_taking_damage && !is_invincible():
		print("takes damage")
		start_invincibility(INVULNERABILITY_SECONDS)

		var damage = BASE_DAMAGE
		if _damage_area.has_method("get_base_damage"):
			damage = _damage_area.get_base_damage()

		take_hit(damage, global_position - _damage_area.global_position)

func take_hit(damage: float, direction: Vector2) -> void:
	PlayerStats.decrement_health(damage)
	if Player:
		Player.velocity += direction.normalized() * BASE_KNOCKBACK

func is_invincible():
	return !InvincibleTimer.is_stopped()

func start_invincibility(time):
	InvincibleTimer.start(time)


func _on_area_entered(area: Area2D) -> void:
	_damage_area = area
	_is_taking_damage = true

func _on_area_exited(area: Area2D) -> void:
	_damage_area = null
	_is_taking_damage = false
