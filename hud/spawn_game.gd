class_name SpawnGame
extends Control


signal spawn_button_success

const RYTHM_TIMER_BASE_TIME = 4.0
const HIT_TIMER_TIME = 1.0
const BUTTON_TIMEOUT_TIMER_TIME = 0.5


@export var rythm_timer: Timer
@export var hit_timer: Timer
@export var button_timeout_timer: Timer
@export var timer_bar: ProgressBar
@export var button_texture_rect: TextureRect
@export var panel: PanelContainer
@export var unit_texture_rect: TextureRect
@export var player: Player


var game_step = 1

var current_key_to_press: int = -1

var last_key_sucess: bool = false

var keys: Array[int] = [
	JOY_BUTTON_A,
	JOY_BUTTON_B,
	JOY_BUTTON_X,
	JOY_BUTTON_Y
	]


var key_to_texture_rect: Dictionary = {
	JOY_BUTTON_A: Rect2(0, 16, 16, 16),
	JOY_BUTTON_B: Rect2(16, 16, 16, 16),
	JOY_BUTTON_X: Rect2(32, 16, 16, 16),
	JOY_BUTTON_Y: Rect2(48, 16, 16, 16),
	}

@onready var button_texture_atlas: AtlasTexture = button_texture_rect.texture


func _ready():
	hit_timer.wait_time = HIT_TIMER_TIME
	rythm_timer.wait_time = RYTHM_TIMER_BASE_TIME
	button_timeout_timer.wait_time = BUTTON_TIMEOUT_TIMER_TIME
	rythm_timer.timeout.connect(_on_rythm_timer_timeout)
	
	
func set_for_player(controller: Player.Controller):
	panel.position.y -= 500
	panel.position.x = 200
	if(controller == Player.Controller.Controller2):
		panel.position.x -= 400 + 144 + 128


func start_game():
	game_step = 1
	rythm_timer.start(RYTHM_TIMER_BASE_TIME)
	hit_timer.start()
	current_key_to_press = keys.pick_random()
	button_texture_atlas.region = key_to_texture_rect[current_key_to_press]
	show()


func stop_game():
	rythm_timer.stop()
	hit_timer.stop()
	current_key_to_press = -1
	last_key_sucess = false
	hide()
	

func set_spawn_unit_texture(texture: Texture):
	unit_texture_rect.texture = texture


func spawn_button_pressed(button_key: int):
	if not keys.has(button_key) or rythm_timer.is_stopped() or current_key_to_press == -1 or not button_timeout_timer.is_stopped():
		return
	button_timeout_timer.start()
	if hit_timer.is_stopped() or button_key != current_key_to_press:
		game_step = 1
		rythm_timer.stop()
		rythm_timer.start(RYTHM_TIMER_BASE_TIME / game_step)
		button_texture_atlas.region.position.y += 16 * 2
		return
	spawn_button_success.emit()
	current_key_to_press = -1
	last_key_sucess = true
	button_texture_atlas.region.position.x += 16 * 4
		

func _process(_d):
	timer_bar.max_value = rythm_timer.wait_time
	timer_bar.value = rythm_timer.wait_time - rythm_timer.time_left
	button_texture_rect.modulate.a = ease(hit_timer.time_left / hit_timer.wait_time, 0.1)


func _on_rythm_timer_timeout():
	hit_timer.start()
	if last_key_sucess:
		game_step = min(RYTHM_TIMER_BASE_TIME/HIT_TIMER_TIME, game_step + 1)
	else:
		game_step = 1
	last_key_sucess = false
	rythm_timer.start(RYTHM_TIMER_BASE_TIME / game_step)
	current_key_to_press = keys.pick_random()
	button_texture_atlas.region = key_to_texture_rect[current_key_to_press]
