class_name UpgradeMenu
extends Control

@export var upgrades: Upgrades
@export var player: Player
@export var current_button: UnitUpgrade

func get_upgrades() -> Array[Node]:
	return upgrades.get_children()


func _input(event):
	if(event.device == player.controller):
		if (event is InputEventJoypadButton):
			if event.button_index == JOY_BUTTON_DPAD_UP:
				var max_index = upgrades.get_child_count() - 1
				var new_index = current_button.get_index() + 1
				if new_index > max_index:
					new_index = 0
				current_button = upgrades.get_child(new_index)
			elif event.button_index == JOY_BUTTON_DPAD_DOWN:
				var max_index = upgrades.get_child_count() - 1
				var new_index = current_button.get_index() - 1
				if new_index < 0:
					new_index = max_index
				current_button = upgrades.get_child(new_index)
