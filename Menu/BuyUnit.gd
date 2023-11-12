class_name UnitUpgrade
extends Button

@export var level = 0
@export var costs = 100
@export var levelLabel: RichTextLabel
@export var costsLabel: RichTextLabel
@export var unit_scene: PackedScene
@export var upgrade_menu: UpgradeMenu


func incrementLevel():
	level = level + 1
	levelLabel.set_text("Level: " + str(level))
	pass


func incrementCosts():
	upgrade_menu.player.pay_gold(costs)
	costs = int(round(costs * 1.05 ** (level / 3)))
	costsLabel.set_text(str(costs) + " Gold")
	pass
	
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
