extends Node

var GameScene := preload("res://scenes/sample.tscn")


func reload_sample_scene() -> void:
	get_node("/root/Sample").free()
	PlayerStats.refresh_player_stats()
	call_deferred('_load_scene', GameScene.instantiate())

func _load_scene(scene: Node) -> void:
	get_tree().root.add_child(scene)
