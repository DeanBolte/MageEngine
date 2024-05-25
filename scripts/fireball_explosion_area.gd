extends Area2D

@onready var CollisionShape: CollisionShape2D = $CollisionShape2D
func _ready() -> void:
	CollisionShape.disabled = true

func activate() -> void:
	print("actvated")
	CollisionShape.disabled = false
