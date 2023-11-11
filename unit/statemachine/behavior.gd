class_name Behavior
extends Node


@export var unit: Unit
@export var start_state: GDScript

var current_state: State = State.new()

func _ready():
	change_state(start_state.new())


func _process(delta: float):
	current_state.run(delta)


func change_state(new_state: State):
	current_state.end()
	current_state = new_state
	current_state.behavior = self
	current_state.start()
