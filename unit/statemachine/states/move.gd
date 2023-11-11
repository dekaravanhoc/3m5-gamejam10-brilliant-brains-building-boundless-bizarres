class_name StateMove
extends State


func start():
	behavior.unit.animated_sprite.play("move")
	behavior.unit.attack_range.area_entered.connect(_on_possible_target_in_range)


func run(delta: float):
	behavior.unit.global_position += behavior.unit.speed * behavior.unit.current_move_direction * delta
	

func _on_possible_target_in_range(_area: Area2D):
	behavior.change_state(StateAttack.new())


func end():
	behavior.unit.attack_range.area_entered.disconnect(_on_possible_target_in_range)
