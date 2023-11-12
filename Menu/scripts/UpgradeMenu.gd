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
			if event.button_index == JOY_BUTTON_DPAD_UP and event.is_pressed() and player.menu.is_visible_in_tree():
				var max_index = upgrades.get_child_count() - 1
				var new_index = current_button.get_index() - 1
				if new_index > max_index:
					new_index = 0
				print(current_button.costsLabel.get_parsed_text(), "current_button before navigation update")
				current_button.hide_navigation_arrow()
				current_button = upgrades.get_child(new_index)
				current_button.show_navigation_arrow()
				print(current_button.costsLabel.get_parsed_text(), "current_button after navigation update")
			elif event.button_index == JOY_BUTTON_DPAD_DOWN and event.is_pressed() and player.menu.is_visible_in_tree():
				var max_index = upgrades.get_child_count() - 1
				var new_index = current_button.get_index() + 1
				if new_index > max_index:
					new_index = 0
				print(current_button.costsLabel.get_parsed_text(), "current_button before navigation update")
				current_button.hide_navigation_arrow()
				current_button = upgrades.get_child(new_index)
				print(new_index, "new_index")
				current_button.show_navigation_arrow()
				print(current_button.costsLabel.get_parsed_text(), "current_button after navigation update")
