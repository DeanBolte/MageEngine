extends Area2D

@export var ParentEnemy: CharacterBody2D
@export var INVULNERABILITY_SECONDS: float = 0.5
@export var BASE_DAMAGE: float = 0.5

@onready var InvincibleTimer: Timer = $Timer

var _is_taking_damage: bool = false
var _damage_area: Node

func _process(delta: float) -> void:
	if _damage_area && _is_taking_damage && InvincibleTimer.is_stopped():
		InvincibleTimer.start(INVULNERABILITY_SECONDS)

		var damage = BASE_DAMAGE
		if _damage_area.has_method("get_base_damage"):
			damage = _damage_area.get_base_damage()

		ParentEnemy.take_hit(damage, global_position - _damage_area.global_position)

func _on_area_entered(area: Area2D) -> void:
	_damage_area = area.owner
	_is_taking_damage = true

func _on_area_exited(area: Area2D) -> void:
	_damage_area = null
	_is_taking_damage = false
