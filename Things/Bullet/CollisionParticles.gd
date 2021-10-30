extends CPUParticles2D
class_name CollisionParticles


func _ready() -> void:
	emitting = true


func _physics_process(_delta):
	if not emitting:
		queue_free()
