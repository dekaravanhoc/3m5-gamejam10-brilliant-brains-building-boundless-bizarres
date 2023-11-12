class_name PlayerHud
extends Control

@export var health_bar: ProgressBar
@export var money_label: Label
@export var hud_panel: PanelContainer


func set_for_player(controller: Player.Controller):
	hud_panel.size = Vector2(750, 120)
	hud_panel.position.y -= 900
	if(controller == Player.Controller.Controller2):
		hud_panel.position.x -= 750
		health_bar.fill_mode = ProgressBar.FILL_END_TO_BEGIN
		money_label.size_flags_horizontal = Control.SIZE_SHRINK_END



func update_money(money):
	money_label.text = "Money: " + str(money)


func update_health(health):
	health_bar.value = health
	
