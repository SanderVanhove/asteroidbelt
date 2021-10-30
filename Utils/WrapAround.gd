extends Node
class_name WrapAround


export(int, 0, 100) var margin: float = 30.0
export(bool) var is_rigid_body: bool = false


onready var screen_size: Vector2 = get_viewport().size


func _ready() -> void:
	set_physics_process(not is_rigid_body)


func wrap_state(state: Physics2DDirectBodyState) -> void:
	var pos: Vector2 = state.transform.origin

	state.transform.origin = Vector2(
		wrapf(pos.x, 0 - margin, screen_size.x + margin),
		wrapf(pos.y, 0 - margin, screen_size.y + margin)
	)


func _physics_process(delta: float) -> void:
	var pos: Vector2 = get_parent().position

	get_parent().position = Vector2(
		wrapf(pos.x, 0 - margin, screen_size.x + margin),
		wrapf(pos.y, 0 - margin, screen_size.y + margin)
	)
