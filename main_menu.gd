class_name MainMenu
extends MarginContainer

@export var player1: Player
@export var player2: Player
@export var p1text: Label
@export var p2text: Label
@export var countdown: Label

var countdown_tween: Tween

var p1_ready = false
var p2_ready = false

var game_running = false


func _input( event ):
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()

	if game_running:
		return
		
	if event is InputEventKey:
		if event.keycode == KEY_ENTER:
			start_game()
	if event is InputEventJoypadButton:
		if event.pressed and not event.is_echo() and event.button_index == JOY_BUTTON_A:
			if event.device == player1.controller:
				p1text.text = "Player 1: Ready"
				p1_ready = true
			if event.device == player2.controller:
				p2text.text = "Player 2: Ready"
				p2_ready = true

			if p1_ready and p2_ready:
				start_countdown()
		
		if not event.pressed and event.button_index == JOY_BUTTON_A:
			if event.device == player1.controller:
				p1text.text = "Player 1: Press A"
				p1_ready = false
			if event.device == player2.controller:
				p2text.text = "Player 2: Press A"
				p2_ready = false

			if not (p1_ready and p2_ready):
				stop_countdown()



func start_countdown():
	if countdown_tween and countdown_tween.is_running():
		return
	
	countdown_tween = create_tween()

	countdown_tween.tween_interval(1)
	countdown_tween.tween_callback(func():
		countdown.text = "3"
		)
	countdown_tween.tween_interval(1)
	countdown_tween.tween_callback(func():
		countdown.text = "2"
		)
	countdown_tween.tween_interval(1)
	countdown_tween.tween_callback(func():
		countdown.text = "1"
		)
	countdown_tween.tween_interval(1)
	countdown_tween.tween_callback(start_game)


func stop_countdown():
	if countdown_tween:
		countdown_tween.kill()
	countdown.text = ""

func start_game():
	if countdown_tween:
		countdown_tween.kill()
	player1.start()
	player2.start()
	game_running = true
	self.hide()
