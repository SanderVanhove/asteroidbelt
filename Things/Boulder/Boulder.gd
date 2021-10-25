extends RigidBody2D


const MAX_SPEED: float = 200.0


func _ready() -> void:
	randomize()

	angular_velocity = randf() * 5
	apply_impulse(Vector2(0, 0), Vector2(
		rand_range(-200, 200),
		rand_range(-200, 200)
	).clamped(MAX_SPEED))
