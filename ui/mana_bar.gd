extends Control

@onready var Background: ColorRect = $Background
@onready var Foreground: ColorRect = $Foreground

func _process(delta: float) -> void:
	Background.size.x = PlayerStats.get_max_mana()
	Foreground.size.x = PlayerStats.get_mana()
