extends Control

var upgradeMenu 

# Called when the node enters the scene tree for the first time.
func _ready():
	upgradeMenu = get_node("Control/UpgradeMenuPlayer1")
	pass # Replace with function body.

func _unhandled_input(event: InputEvent):
	if (event is InputEventKey and event.keycode == KEY_ESCAPE and event.is_pressed()):
		upgradeMenu.visible = !upgradeMenu.visible
		print(event, 'event')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
