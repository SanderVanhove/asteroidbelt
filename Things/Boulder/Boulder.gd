extends RigidBody2D


const MAX_SPEED: float = 0.0


onready var _wrap_around: WrapAround = $WrapAround


func _ready() -> void:
	randomize()

	angular_velocity = randf() * 5
	apply_impulse(Vector2(0, 0), Vector2(
		rand_range(-200, 200),
		rand_range(-200, 200)
	).clamped(MAX_SPEED))


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	_wrap_around.wrap_state(state)


func got_hit(hitting_object: Node2D) -> void:
	apply_central_impulse(Vector2(0, -50).rotated(hitting_object.rotation))
