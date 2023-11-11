class_name StateAttack
extends State


func start():
	attack()


func attack():
	if behavior.unit.attack_range.get_overlapping_areas().is_empty():
		behavior.change_state(StateMove.new())
		return
	
	behavior.unit.animated_sprite.play("attack")
	behavior.unit.animated_sprite.animation_finished.connect(attack)
	await behavior.unit.get_tree().create_timer(behavior.unit.hit_time).timeout
	for enemy in behavior.unit.attack_box.get_overlapping_bodies():
		if enemy.has_method("hit"):
			enemy.hit(behavior.unit.dps * behavior.unit.attack_speed)
	
