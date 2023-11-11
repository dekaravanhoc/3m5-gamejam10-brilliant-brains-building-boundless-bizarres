class_name Player
extends Area2D

enum Controller {Controller1, Controller2}

var health: int = 100
var money: int = 0
var dmg = 0
var def: int = 1

@export var controller: Controller

var input_device: int = 0
signal health_depleted

func _ready():
	if controller == Controller.Controller1:
		collision_layer = 1
		input_device = 0
	else:
		collision_layer = 2
		input_device = 1

func _process(delta):
	pass
	
func _input(event):
	if(event.is_action_pressed("debug_player2_create") && controller == Controller.Controller2):
		create_unit()
		
	if(event.device != input_device):
		return
	if(event.is_action_pressed("player_create_unit")):
		create_unit()
	if(event.is_action_pressed("player_open_menu")):
		open_menu()

func create_unit():
	print("unit")
	var current_unit = preload("res://unit/unit.tscn").instantiate()
	if(controller == Controller.Controller1):
		current_unit.spawn(self.get_parent(), Unit.PLAYER.Player1, self.global_position + Vector2(20,0))
	if(controller == Controller.Controller2):
		current_unit.spawn(self.get_parent(), Unit.PLAYER.Player2, self.global_position - Vector2(20,0))
	
func hit(amount: int):
	health = health - amount
	if health < 0:
		health_depleted.emit()

func open_menu():
	print("menu")

