class_name Unit
extends Area2D

signal health_changed(value: int)
signal killed

enum PLAYER {Player1, Player2}

@export var animated_sprite: AnimatedSprite2D
@export var health: int = 10
@export var dps: int = 2
@export var def: int = 0
@export var speed: int = 100
@export var attack_speed: float = 1.0
@export var gold_drop: int = 1

var current_player: PLAYER = PLAYER.Player1

var current_move_direction: Vector2:
	get:
		if current_player == PLAYER.Player1:
			return Vector2.RIGHT
		else:
			return Vector2.LEFT

var current_health: int:
	set(value):
		current_health = min(health, max(0, value))
		health_changed.emit(current_health)


func _ready():
	current_health = health
	if current_player == PLAYER.Player1:
		collision_layer = 1
		collision_mask = 2
	else:
		collision_layer = 2
		collision_mask = 1
		animated_sprite.flip_h = current_player == PLAYER.Player1


func spawn(parent_to_spawn_in: Node2D, player: PLAYER, spawn_position: Vector2):
	global_position = spawn_position
	current_player = player
	parent_to_spawn_in.add_child(self)
