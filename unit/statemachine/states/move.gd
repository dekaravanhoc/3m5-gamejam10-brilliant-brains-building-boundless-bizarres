class_name StateMove
extends State


func start():
	behavior.unit.animated_sprite.play("move")


func run(delta: float):
	behavior.unit.global_position += behavior.unit.speed * behavior.unit.current_move_direction * delta
