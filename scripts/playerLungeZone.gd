extends Area2D

@export var ParentEnemy: CharacterBody2D
@onready var PlayerLungeTimer := $PlayerLungeCycle
@onready var LungerTimer: Timer = $LungeTimer

@export var LUNGE_CYCLE: float = 3.0
@export var LUNGE_LENGTH: float = 0.5

var player = null

func _physics_process(delta: float) -> void:
	if can_see_player() && PlayerLungeTimer.is_stopped():
		ParentEnemy.lunge_at()
		LungerTimer.start(LUNGE_LENGTH)
		PlayerLungeTimer.start(LUNGE_CYCLE)


func _on_body_entered(body: Node2D) -> void:
	player = body

func _on_body_exited(body: Node2D) -> void:
	player = null


func can_see_player():
	return (player != null)
