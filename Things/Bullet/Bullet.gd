extends Area2D
class_name Bullet


var CollisionParticlesClass = preload("res://Things/Bullet/CollisionParticles.tscn")


const SPEED: float = 10.0


onready var _particles: CPUParticles2D = $CPUParticles2D
onready var _tween: Tween = $Tween


func _process(delta: float) -> void:
	position += Vector2(0, -SPEED).rotated(rotation)


func _on_Bullet_body_entered(body: Node) -> void:
	if body.is_in_group('boulder'):
		body.got_hit(self)

		var collision_particles = CollisionParticlesClass.instance()
		collision_particles.global_transform = global_transform
		get_parent().add_child(collision_particles)

		queue_free()


func _on_ExistenceTimer_timeout() -> void:
	_tween.interpolate_property(self, "modulate:a", 1, 0, .2)
	_tween.start()
	yield(_tween, "tween_all_completed")
	queue_free()
