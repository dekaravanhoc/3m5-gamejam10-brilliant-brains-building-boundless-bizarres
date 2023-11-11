class_name StateAttack
extends State

var current_target: Area2D

var self_reference_for_await: StateAttack


func start():
	await behavior.get_tree().create_timer(randf_range(0.1, 0.3)).timeout
	_attack()


func _attack():
	if behavior.unit.attack_range.get_overlapping_areas().is_empty():
		behavior.change_state(StateMove.new())
		return
	
	behavior.unit.animated_sprite.play("attack_start")
	await behavior.unit.animated_sprite.animation_finished
	if behavior.current_state != self:
		return

	if behavior.unit.attack_range.get_overlapping_areas().is_empty():
		behavior.change_state(StateMove.new())
		return
	if not current_target:
		current_target = behavior.unit.attack_box.get_overlapping_areas()[0]
		if current_target.has_signal("killed"):
			current_target.killed.connect(_attack)
	if current_target.has_method("hit"):
		current_target.hit(behavior.unit.dps * behavior.unit.attack_speed)
	
	behavior.unit.animated_sprite.play("attack_end")
	await behavior.unit.animated_sprite.animation_finished
	
	if behavior.current_state == self:
		_attack()

func end():
	self_reference_for_await = self
	await behavior.unit.get_tree().create_timer(2).timeout
	self_reference_for_await = null
