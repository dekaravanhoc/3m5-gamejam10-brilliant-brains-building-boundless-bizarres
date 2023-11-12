class_name StateMoveDefend
extends State

var self_reference_for_await: StateMoveDefend

func start():
	behavior.unit.damage_taken_mod = 5
	behavior.unit.animated_sprite.play("move")
	await behavior.unit.get_tree().create_timer(randf_range(2.0, 4.0)).timeout
	if behavior.current_state != self:
		return
	behavior.change_state(StateDefend.new())


func run(delta: float):
	behavior.unit.global_position += behavior.unit.speed * behavior.unit.current_move_direction * delta


func end():
	behavior.unit.damage_taken_mod = 1
	behavior.unit.animated_sprite.play("charge")
	self_reference_for_await = self
	await behavior.unit.animated_sprite.animation_finished
	self_reference_for_await = null
