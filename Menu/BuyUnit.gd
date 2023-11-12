extends Node

@export var level = 0
@export var costs = 100
@export var levelLabel: RichTextLabel
@export var costsLabel: RichTextLabel
@export var id: String
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = getPlayer()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func incrementLevel():
	level = level + 1
	levelLabel.set_text("Level: " + str(level))
	pass
	
func getPlayer():
	var upgradeMenuPlayer = self.get_parent().get_parent().get_parent().get_parent().get_parent()
	var player = upgradeMenuPlayer.player
	return player

func incrementCosts():
	player.money = player.money - costs
	costs = int(round(costs * 1.05 ** (level / 3)))
	costsLabel.set_text(str(costs) + " Gold")
	pass
	
func addToPlayerUnitsArray():
	print(player.availableUnits.has(self), player.availableUnits.find(self))
	var index = player.availableUnits.find(self)
	if (index >= 0):
		player.availableUnits.remove_at(index)
		player.availableUnits.append(self)
	elif (index == -1):
		player.availableUnits.append(self)
	print(player.availableUnits)

func buy_upgrade():
	print("buy: ", id)
	var player = getPlayer()
	var playerMoney = player.money
	
	if (playerMoney >= costs):
		incrementLevel()
		incrementCosts()
		addToPlayerUnitsArray()


func _on_pressed():
	buy_upgrade()
func _on_focus_changed(control: Control):
	print(control, "Test")

func _input(event):
	if(get_viewport().gui_get_focus_owner() == self):
		if(event.is_action_pressed("player_buy_upgrade")):
			_on_pressed()
