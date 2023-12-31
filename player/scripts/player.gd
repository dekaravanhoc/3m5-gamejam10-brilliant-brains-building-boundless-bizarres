class_name Player
extends Area2D

enum Controller {Controller1, Controller2}

var health: int = 10000
var money: int = 0
var dmg = 0
var def: int = 1

var availableUnits = []
var current_unit: UnitUpgrade

@export var controller: Controller
@export var enemy_player: Player
@export var win_message_label: Label
@export var menu: UpgradeMenu
@export var hud: PlayerHud
@export var spawn_game: SpawnGame
@export var portal_anim: AnimatedSprite2D
@export var explosion: CPUParticles2D

var input_device: int = 0
signal health_depleted

var current_health: int:
	set(value):
		current_health = min(health, max(0, value))
		if current_health/float(health) <= 0.2:
			portal_anim.play("20")
		elif current_health/float(health) <= 0.6:
			portal_anim.play("60")
		
		if current_health == 0:
			health_depleted.emit()
			win_message_label.show()
			if(controller == Controller.Controller1):
				win_message_label.text = "Player 2 WON!!!!"
			else:
				win_message_label.text = "Player 1 WON!!!!"

			for unit in get_tree().get_nodes_in_group("Units"):
				unit.behavior.change_state(StateDie.new())
			spawn_game.hide()
			spawn_game.stop_game()
			hud.hide()
			explosion.emitting = true
			var tween = create_tween()
			tween.tween_property(portal_anim, "modulate:a", 0, 1)
			await get_tree().create_timer(3).timeout
			get_tree().reload_current_scene()
			
func _ready():
	hide()
	hud.hide()
	spawn_game.hide()
	set_process_input(false)

func start():
	show()
	hud.show()
	spawn_game.show()
	set_process_input(true)
	current_health = health
	hud.update_health(current_health)
	hud.update_money(money)
	hud.position = global_position
	hud.set_for_player(controller)
	spawn_game.position = global_position
	spawn_game.set_for_player(controller)
	if not availableUnits.is_empty():
		current_unit = availableUnits[0]
		spawn_game.set_spawn_unit_texture(current_unit.unit_texture)
	spawn_game.spawn_button_success.connect(create_unit)
	spawn_game.start_game()
	
	enemy_player.health_depleted.connect(func():
			spawn_game.hide()
			spawn_game.stop_game()
			hud.hide()
			)
	
	
	if controller == Controller.Controller1:
		collision_layer = 1
		input_device = 0
	else:
		collision_layer = 2
		input_device = 1

	
func _input(event):
	if(event.device != input_device):
		return
	if(event.is_action_pressed("player_open_menu")):
		open_menu(event.device)
	if menu.visible:
		return
	if (event is InputEventJoypadButton and event.pressed and not event.is_echo()):
		spawn_game.spawn_button_pressed(event.button_index)
		if event.button_index == JOY_BUTTON_DPAD_DOWN:
			var new_index = wrapi(availableUnits.find(current_unit) + 1, 0, availableUnits.size())
			current_unit = availableUnits[new_index]
			spawn_game.set_spawn_unit_texture(current_unit.unit_texture)
		if event.button_index == JOY_BUTTON_DPAD_UP:
			var new_index = wrapi(availableUnits.find(current_unit) - 1, 0, availableUnits.size())
			current_unit = availableUnits[new_index]
			spawn_game.set_spawn_unit_texture(current_unit.unit_texture)
		if event.button_index == JOY_BUTTON_LEFT_SHOULDER:
			create_unit()


func create_unit():
	if(controller == Controller.Controller1):
		var unit_to_spawn = current_unit.unit_scene.instantiate()
		unit_to_spawn.spawn(self.get_parent(), Unit.PLAYER.Player1, self.global_position, enemy_player.collect_gold, current_unit.level)
	if(controller == Controller.Controller2):
		var unit_to_spawn = current_unit.unit_scene.instantiate()
		unit_to_spawn.spawn(self.get_parent(), Unit.PLAYER.Player2, self.global_position, enemy_player.collect_gold, current_unit.level)

func hit(amount: int):
	current_health -= amount
	hud.update_health(100.0 * current_health / health)
		


func collect_gold(amount: int):
	money += amount
	hud.update_money(money)

func pay_gold(amount: int):
	if not has_enough_gold(amount):
		return
	money -= amount
	hud.update_money(money)

func has_enough_gold(amount: int):
	return money >= amount

func open_menu(player: int):
	var children: Button = menu.get_upgrades()[0]
	menu.visible = !menu.is_visible_in_tree()
	if menu.visible:
		spawn_game.stop_game()
	else:
		spawn_game.start_game()
	#children.grab_focus()

