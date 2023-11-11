class_name StateSpawn
extends State



func start():
	var tween: Tween = behavior.unit.create_tween()

	tween.tween_property(behavior.unit.animated_sprite, "modulate:a", 1.0, 1).from(0.0)
	tween.parallel()
	tween.tween_property(behavior.unit.animated_sprite, "scale:y", behavior.unit.animated_sprite.scale.y, 1).from(0.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel()
	tween.tween_property(behavior.unit.animated_sprite, "scale:x", behavior.unit.animated_sprite.scale.x, 1).from(0.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(func():
			behavior.change_state(StateMove.new())
			)

