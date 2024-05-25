extends Node2D

@export var WANDER_RANGE: int = 256

@onready var start_position = global_position
@onready var target_position = global_position

@onready var timer = $Timer

func _ready() -> void:
	update_target_position()

func update_target_position():
	var target_vector = Vector2(randf_range(-WANDER_RANGE, WANDER_RANGE), randf_range(-WANDER_RANGE, WANDER_RANGE))
	target_position = start_position + target_vector

func get_time_left():
	return timer.time_left

func start_wander_timer(duration):
	timer.start(duration)


func _on_timer_timeout() -> void:
	update_target_position()
