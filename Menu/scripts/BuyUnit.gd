class_name UnitUpgrade
extends Button

@export var level = 0
@export var costs = 100
@export var levelLabel: RichTextLabel
@export var costsLabel: RichTextLabel
@export var unit_scene: PackedScene
@export var upgrade_menu: UpgradeMenu
@export var already_available: bool = false

@onready var unit_texture: Texture = $HBoxContainer/TextureRect.texture

func _ready():
	if already_available:
		level = 1
		costs = int(round(costs * 1.05 ** (level / 3)))
		costsLabel.set_text(str(costs) + " Gold")
		addToPlayerUnitsArray()

func incrementLevel():
	level = level + 1
	levelLabel.set_text("Level: " + str(level))
	


func incrementCosts():
	upgrade_menu.player.pay_gold(costs)
	costs = int(round(costs * 1.05 ** (level / 3)))
	costsLabel.set_text(str(costs) + " Gold")

	
func addToPlayerUnitsArray():
	print(upgrade_menu.player.availableUnits.has(self), upgrade_menu.player.availableUnits.find(self))
	if not upgrade_menu.player.availableUnits.has(self):
		upgrade_menu.player.availableUnits.append(self)
	print(upgrade_menu.player.availableUnits)

func buy_upgrade():
	
	if (upgrade_menu.player.has_enough_gold(costs)):
		incrementLevel()
		incrementCosts()
		addToPlayerUnitsArray()


func _on_pressed():
	buy_upgrade()
func _on_focus_changed(control: Control):
	print(control, "Test")

func _input(event):
	if(event.device == upgrade_menu.player.controller and upgrade_menu.current_button == self):
		if(event.is_action_pressed("player_buy_upgrade")):
			_on_pressed()
	
		if (event.is_action_pressed("player_menu_down") and player.controller == event.device):
			print("down pressed for player ", event.device)
		if (event.is_action_pressed("player_menu_up") and player.controller == event.device):
			print("up pressed for player ", event.device)
