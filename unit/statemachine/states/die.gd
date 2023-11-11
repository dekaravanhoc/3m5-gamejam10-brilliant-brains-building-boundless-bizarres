class_name StateDie
extends State


func start():
	behavior.stopped = true
	behavior.unit.monitorable = false
	behavior.unit.animated_sprite.play("die")
	behavior.unit.killed.emit()
	behavior.unit.gold_dropped.emit(behavior.unit.gold_drop)
	behavior.unit.animated_sprite.animation_finished.connect(behavior.unit.queue_free)
