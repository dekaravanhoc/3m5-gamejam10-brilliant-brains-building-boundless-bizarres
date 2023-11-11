class_name StateDie
extends State


func start():
	behavior.stopped = true
	behavior.unit.monitorable = false
	behavior.unit.animated_sprite.play("die")
	behavior.unit.killed.emit()
	behavior.unit.gold_dropped.emit(behavior.unit.gold_drop)
	behavior.unit.animated_sprite.animation_finished.connect(func():
		var tween: Tween = behavior.create_tween()
		tween.tween_interval(1.0)
		await tween.finished
		behavior.unit.queue_free()
		)
