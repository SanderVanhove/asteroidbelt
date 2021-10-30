extends RigidBody2D
class_name Boulder


var CollisionParticlesClass = preload("res://Things/Boulder/CollisionParticles.tscn")


var big_sprites: Array = [
	preload("res://Things/Boulder/Big_Boulder.png"),
	preload("res://Things/Boulder/Big_Boulder2.png")
]

var small_sprites: Array = [
	preload("res://Things/Boulder/Small_boulder.png"),
	preload("res://Things/Boulder/Small_boulder2.png")
]


const MAX_SPEED: float = 300.0


export(bool) var is_small: bool = false
var is_hit: bool = false
var initial_impulse: Vector2


onready var _wrap_around: WrapAround = $WrapAround
onready var _sprite: Sprite = $Visual/Sprite


func _ready() -> void:
	is_hit = is_small
	#_sprite.self_modulate = Color.red

	randomize()

	_sprite.texture = big_sprites[int(floor(rand_range(0, 2)))] if not is_small else small_sprites[int(floor(rand_range(0, 2)))]

	rotate(randf())
	angular_velocity = randf() * 5

	if is_small: _wrap_around.margin = 20

	linear_velocity = Vector2.ZERO
	apply_impulse(Vector2(0, 0), Vector2(
		rand_range(-300, 300),
		rand_range(-300, 300)
	).clamped(MAX_SPEED))


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	_wrap_around.wrap_state(state)


func got_hit(hitting_object: Node2D) -> void:
	apply_central_impulse(Vector2(0, -100).rotated(hitting_object.rotation))

	if is_hit:
		var collision_particles = CollisionParticlesClass.instance()
		collision_particles.global_transform = global_transform
		get_parent().add_child(collision_particles)
		if is_small: collision_particles.scale *= .5

		if not is_small:
			for i in range(randi() % 2 + 2):
				var new_boulder: Boulder = self.duplicate()
				new_boulder.is_small = true
				get_parent().add_child(new_boulder)

		queue_free()

	is_hit = true
	_sprite.self_modulate = Color(1, .2, 0)


func _on_CollisionTimer_timeout() -> void:
	set_collision_layer_bit(0, true)
