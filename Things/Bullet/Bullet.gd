extends Area2D
class_name Bullet


const SPEED: float = 10.0


func _process(delta: float) -> void:
	position += Vector2(0, -SPEED).rotated(rotation)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
