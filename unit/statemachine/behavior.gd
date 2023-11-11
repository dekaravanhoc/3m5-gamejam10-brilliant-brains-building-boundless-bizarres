class_name Behavior
extends Node


@export var unit: Unit
@export var start_state: GDScript

var stopped = false

var current_state: State = State.new()

# if the last state had awaits etc.
var last_state: State


func _ready():
	change_state(start_state.new())


func _process(delta: float):
	current_state.run(delta)


func change_state(new_state: State):
	if stopped:
		return
	current_state.end()
	# last_state = current_state
	current_state = new_state
	current_state.behavior = self
	current_state.start()
