extends Area2D
class_name Bullet


var CollisionParticlesClass = preload("res://Things/Bullet/CollisionParticles.tscn")


const SPEED: float = 10.0


onready var _particles: CPUParticles2D = $CPUParticles2D


func _process(delta: float) -> void:
	position += Vector2(0, -SPEED).rotated(rotation)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Bullet_body_entered(body: Node) -> void:
	if body.is_in_group('boulder'):
		body.got_hit(self)

		var collision_particles = CollisionParticlesClass.instance()
		collision_particles.global_transform = global_transform
		get_parent().add_child(collision_particles)

		queue_free()
