extends Node

const MAX_PLAYER_HEALTH := 100.0
const MAX_PLAYER_MANA := 100.0

var _max_health: float = MAX_PLAYER_HEALTH
var _health: float = MAX_PLAYER_HEALTH
var _max_mana: float = MAX_PLAYER_MANA
var _mana: float = MAX_PLAYER_MANA


func refresh_player_stats() -> void:
	_max_health = MAX_PLAYER_HEALTH
	_health = MAX_PLAYER_HEALTH
	_max_mana = MAX_PLAYER_MANA
	_mana = MAX_PLAYER_MANA


func set_max_health(value: float) -> void:
	_max_health = value

func set_health(value: float) -> void:
	_health = value
	if _health <= 0:
		GameEvents.no_health.emit()

func decrement_health(value: float) -> void:
	set_health(_health - value)

func set_max_mana(value: float) -> void:
	_max_mana = value

func set_mana(value: float) -> void:
	_mana = value
	if _mana <= 0:
		GameEvents.no_mana.emit()

func decrement_mana(value: float)-> void:
	set_mana(_mana - value)


func get_max_health() -> float:
	return _max_health

func get_health() -> float:
	return _health

func get_max_mana() -> float:
	return _max_mana

func get_mana() -> float:
	return _mana


