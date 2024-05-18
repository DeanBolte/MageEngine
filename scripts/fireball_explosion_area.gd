extends Area2D

func _ready() -> void:
	monitorable = false


func activate() -> void:
	monitorable = true
