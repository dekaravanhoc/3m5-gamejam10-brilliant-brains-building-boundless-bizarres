class_name StateAttack
extends State


func start():
	await behavior.get_tree().create_timer(randf_range(0.1, 0.3)).timeout
	_attack()


func _attack():
	if behavior.unit.attack_range.get_overlapping_areas().is_empty():
		behavior.change_state(StateMove.new())
		return
	
	behavior.unit.animated_sprite.play("attack_start")
	await behavior.unit.animated_sprite.animation_finished
	for enemy in behavior.unit.attack_box.get_overlapping_areas():
		if enemy.has_method("hit"):
			enemy.hit(behavior.unit.dps * behavior.unit.attack_speed)
	behavior.unit.animated_sprite.play("attack_end")
	await behavior.unit.animated_sprite.animation_finished
	if behavior.current_state == self:
		_attack()

