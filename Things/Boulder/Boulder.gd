extends RigidBody2D
class_name Boulder

signal cracked(position, is_small)

var CollisionParticlesClass = preload("res://Things/Boulder/CollisionParticles.tscn")
var ExtraLifeClass = preload("res://Things/ExtraLife/ExtraLife.tscn")


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
onready var _large_collision_shape: CollisionPolygon2D = $CollisionPolygon2D
onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	is_hit = is_small

	randomize()

	_sprite.texture = big_sprites[int(floor(rand_range(0, 2)))] if not is_small else small_sprites[int(floor(rand_range(0, 2)))]

	rotate(randf())
	angular_velocity = randf() * 5

	if is_small:
		_wrap_around.margin = 20
		_large_collision_shape.queue_free()
		_sprite.self_modulate = Color(1, .2, 0)

	linear_velocity = Vector2.ZERO
	apply_impulse(Vector2(0, 0), Vector2(
		rand_range(-300, 300),
		rand_range(-300, 300)
	).clamped(MAX_SPEED))

	bounce = .5

	_sprite.modulate.a = 0
	_animation_player.play("appear")


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	_wrap_around.wrap_state(state)


func got_hit(hitting_object: Node2D) -> void:
	apply_central_impulse(Vector2(0, -100).rotated(hitting_object.rotation))

	if is_hit:
		var collision_particles = CollisionParticlesClass.instance()
		collision_particles.global_transform = global_transform
		if is_small: collision_particles.scale *= .5
		get_parent().add_child(collision_particles)

		emit_signal("cracked", is_small, position)

		if not is_small and randf() < .1:
			var extra_life = ExtraLifeClass.instance()
			extra_life.global_position = global_position
			get_parent().add_child(extra_life)

		queue_free()

	is_hit = true
	_sprite.self_modulate = Color(1, .2, 0)


func _on_CollisionTimer_timeout() -> void:
	set_collision_layer_bit(0, true)


func _on_Boulder_body_entered(body: Node) -> void:
	if body.is_in_group("boulder"):
		$BoulderHit.play()
	if not body.is_in_group("player"):
		return

	body.hit(self)
	got_hit(body)
