class_name StateDefend
extends State

var self_reference_for_await: StateDefend

# Called when the node enters the scene tree for the first time.
func start():
	behavior.unit.animated_sprite.play("defend")


func end():
	self_reference_for_await = self
	await behavior.unit.get_tree().create_timer(2).timeout
	self_reference_for_await = null
