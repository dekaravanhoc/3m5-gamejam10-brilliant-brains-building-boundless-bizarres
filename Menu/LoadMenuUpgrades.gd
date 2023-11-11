extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var upgradeUnitUI = load("res://Menu/UpgradeUnit.tscn")
	var instance = upgradeUnitUI.instantiate()
	var instance2 = upgradeUnitUI.instantiate()
	var instance3 = upgradeUnitUI.instantiate()
	add_child(instance)
	add_child(instance2)
	add_child(instance3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_menu_button_up():
	# jump back to main scene
	pass # Replace with function body.
