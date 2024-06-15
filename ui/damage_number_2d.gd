class_name DamageNumber2D
extends Node2D

@onready var label: Label = $LabelContainer/Label
@onready var label_container: Control = $LabelContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func set_values_and_animate(value: String, start_pos: Vector2, height: float, spread: float) -> void:
	label.text = value
	animation_player.play("Rise and Fade")

	var tween := get_tree().create_tween()
	var end_pos = Vector2(randf_range(-spread, spread), -height) + start_pos
	var tween_length = animation_player.get_animation("Rise and Fade").length

	tween.tween_property(label_container, "global_position", end_pos, tween_length).from(start_pos)

func remove() -> void:
	animation_player.stop()
	if is_inside_tree():
		get_parent().remove_child(self)
