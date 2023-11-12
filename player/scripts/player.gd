class_name Player
extends Area2D

enum Controller {Controller1, Controller2}

var health: int = 10000
var money: int = 0
var dmg = 0
var def: int = 1

var availableUnits = []

@export var controller: Controller
@export var enemy_player: Player
@export var win_message_label: Label
@export var menu: Control
@export var hud: PlayerHud
@export var spawn_game: SpawnGame

var input_device: int = 0
signal health_depleted

var current_health: int:
	set(value):
		current_health = min(health, max(0, value))
		if current_health == 0:
			health_depleted.emit()
			win_message_label.show()
			if(controller == Controller.Controller1):
				win_message_label.text = "Player 2 WON!!!!"
			else:
				win_message_label.text = "Player 1 WON!!!!"

			for unit in get_tree().get_nodes_in_group("Units"):
				unit.behavior.change_state(StateDie.new())
			await get_tree().create_timer(3).timeout
			get_tree().reload_current_scene()
			

func _ready():
	current_health = health
	hud.update_health(current_health)
	hud.position = global_position
	hud.set_for_player(controller)
	spawn_game.position = global_position
	spawn_game.set_for_player(controller)
	spawn_game.spawn_button_success.connect(create_unit)
	spawn_game.start_game()
	
	
	if controller == Controller.Controller1:
		collision_layer = 1
		input_device = 0
	else:
		collision_layer = 2
		input_device = 1

	
func _input(event):
	if(event.is_action_pressed("debug_player2_create") && controller == Controller.Controller2):
		create_unit()
		
	#print(event, 'event')
	if(event.device != input_device):
		return
	if (event is InputEventJoypadButton and event.pressed and not event.is_echo()):
		spawn_game.spawn_button_pressed(event.button_index)
#	if(event.is_action_pressed("player_open_menu")):
#		open_menu(event.device)

func create_unit():
	if(controller == Controller.Controller1):
		var current_unit = preload("res://unit/unit.tscn").instantiate()
		current_unit.spawn(self.get_parent(), Unit.PLAYER.Player1, self.global_position + Vector2(20,0), enemy_player.collect_gold)
	if(controller == Controller.Controller2):
		var current_unit = preload("res://unit/unit_boxer.tscn").instantiate()
		current_unit.spawn(self.get_parent(), Unit.PLAYER.Player2, self.global_position - Vector2(20,0), enemy_player.collect_gold)
	
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
	var children: Button = menu.get_children()[0].get_children()[0].get_children()[0].get_children()[0].get_children()[0].get_children()[0]
	menu.visible = !menu.is_visible_in_tree()
	children.grab_focus()
	print("menu", player)

