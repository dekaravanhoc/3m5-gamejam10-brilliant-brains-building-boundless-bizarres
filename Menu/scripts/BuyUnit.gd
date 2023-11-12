class_name UnitUpgrade
extends Button

@export var level = 0
@export var costs = 100
@export var levelLabel: RichTextLabel
@export var costsLabel: RichTextLabel
@export var unit_scene: PackedScene
@export var upgrade_menu: UpgradeMenu
@export var already_available: bool = false

var navigationArrow: Panel

@onready var unit_texture: Texture = $HBoxContainer/TextureRect.texture

func _ready():
	navigationArrow = get_node("Panel")
	costsLabel.set_text(str(costs) + " Gold")
	if already_available:
		level = 1
		costs = int(round(costs * 1.05 ** (level / 4) / 2))
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


func show_navigation_arrow():
	navigationArrow.visible = true

func hide_navigation_arrow():
	navigationArrow.visible = false

func _on_pressed():
	buy_upgrade()

func _input(event):
	if(event.device == upgrade_menu.player.controller and upgrade_menu.current_button == self):
		if(event.is_action_pressed("player_buy_upgrade")):
			_on_pressed()
