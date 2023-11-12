class_name Unit
extends Area2D


signal health_changed(value: int)
signal gold_dropped(amount: int)
signal killed

enum PLAYER {Player1, Player2}

enum UpgradeFunctions {Normal, Attack, HP}

@export var animated_sprite: AnimatedSprite2D
@export var attack_box: Area2D
@export var attack_range: Area2D
@export var behavior: Behavior
@export var health: int = 10
@export var dps: int = 2
@export var def: int = 0
@export var speed: int = 100
@export var gold_drop: int = 1
@export var upgrade_function: UpgradeFunctions = UpgradeFunctions.Normal
@export var damage_taken_mod: int = 1
@export var unit_id: String

var hit_tween: Tween
var current_player: PLAYER = PLAYER.Player1
var gold_collect_function: Callable = func(_amount: int): return

var current_move_direction: Vector2:
	get:
		if current_player == PLAYER.Player1:
			return Vector2.RIGHT
		else:
			return Vector2.LEFT


var upgrade_functions: Dictionary = {
	UpgradeFunctions.Normal: func(level: int):
		health *= level
		dps *= level
		,
	UpgradeFunctions.Attack: func(level: int):
		health *= int(level/2)
		dps *= level * 2
		,
	UpgradeFunctions.HP: func(level: int):
		health *= level * 2
		dps *= int(level/2)
		,
	}


@onready var attack_speed: float = (animated_sprite.sprite_frames.get_frame_count("attack_start") + animated_sprite.sprite_frames.get_frame_count("attack_end")) / 8.0

var current_health: int:
	set(value):
		current_health = min(health, max(0, value))
		health_changed.emit(current_health)
		if current_health == 0:
			behavior.change_state(StateDie.new())


func _ready():
	current_health = health
	if current_player == PLAYER.Player1:
		collision_layer = 1
		attack_box.collision_mask = 2
		attack_range.collision_mask = 2
	else:
		collision_layer = 2
		attack_box.collision_mask = 1
		attack_range.collision_mask = 1
		scale.x *= -1


func spawn(parent_to_spawn_in: Node2D, player: PLAYER, spawn_position: Vector2, gold_collect_function_to_use: Callable, level: int = 1):
	print("Spawn with level ", level)
	global_position = spawn_position
	current_player = player
	gold_collect_function = gold_collect_function_to_use
	upgrade_functions[upgrade_function].call(level)
	parent_to_spawn_in.add_child(self)


func hit(damage: int):
	current_health -= damage * damage_taken_mod
	if hit_tween and hit_tween.is_running():
		return
	if hit_tween:
		hit_tween.kill()

	hit_tween = create_tween()

	hit_tween.tween_property(animated_sprite, "modulate", Color.RED, 0.25).from(Color.WHITE).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	hit_tween.tween_property(animated_sprite, "modulate", Color.WHITE, 0.25).from(Color.RED).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
