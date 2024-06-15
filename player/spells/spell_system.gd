class_name SpellSystem
extends Node2D

@export var player: Player

@onready var booksContianer: Node2D = $Books
@onready var fireBallBook: Book = $Books/FireBallBook
@onready var _books_available: Dictionary = {
	Books.FIREBALL: fireBallBook
}

# Control
var _aim_direction: Vector2
var _is_book_active: bool = false

# Spell Selection
var _primary_book: Books
# Dictionary<Spells, Spell>

enum Books { FIREBALL }


func _ready() -> void:
	_primary_book = Books.FIREBALL

func _unhandled_input(event: InputEvent) -> void:
	var mouse_motion = event as InputEventMouseMotion

	if mouse_motion:
		_aim_direction = (mouse_motion.global_position - player.global_position).normalized()

func _process(delta: float) -> void:
	_player_input()

	if player:
		booksContianer.rotation = _aim_direction.angle() + PI/2
		booksContianer.global_position = player.global_position

	var book: Book = _get_book()
	if book:
		book.set_is_spell_active(_is_book_active)
		book.set_aim_direction(_aim_direction)
		book.set_spell_position(player.global_position)

func _player_input() -> void:
	if player == null:
		return

	# priamry spell active
	var primary_spell_input = Input.is_action_pressed("spell_primary")

	if primary_spell_input and !is_book_active():
		set_is_book_active(true)
		player.set_max_velocity(player.SPELL_MAX_VELOCITY)
	if !primary_spell_input and is_book_active():
		set_is_book_active(false)
		player.set_max_velocity(player.MAX_VELOCITY)

func _get_book() -> Book:
	return _books_available[_primary_book]


func set_is_book_active(activated: bool) -> void:
	_is_book_active = activated

func is_book_active() -> bool:
	return _is_book_active
