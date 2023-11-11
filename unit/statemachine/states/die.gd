class_name StateDie
extends State


func start():
	behavior.unit.animated_sprite.play("die")
	behavior.unit.killed.emit()
	behavior.unit.animated_sprite.animation_finished.connect(behavior.unit.queue_free)
