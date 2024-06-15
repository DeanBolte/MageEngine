class_name Book
extends Node2D

var _spell_scene: Resource
var _spell_state: SpellStates
var _is_active: bool
var _aim_direction: Vector2
var _spell_position: Vector2

var _spawn_offset: float

enum SpellStates { CHANTING, CASTING, COOLDOWN }

func _spawn():
	var spell: Spell = _spell_scene.instantiate()
	spell.global_position = _spell_position + _aim_direction * _spawn_offset
	spell.direction = _aim_direction
	get_parent().get_parent().get_node("Spells").add_child(spell)


# Getters and Setters
func get_spell_scene():
	return _spell_scene

func get_spell_state():
	return _spell_state

func is_spell_active() -> bool:
	return _is_active

func set_is_spell_active(active: bool) -> void:
	_is_active = active

func get_aim_direction() -> Vector2:
	return _aim_direction

func set_aim_direction(value: Vector2):
	_aim_direction = value

func set_spell_position(value: Vector2) -> void:
	_spell_position = value

func get_spell_position() -> Vector2:
	return _spell_position
