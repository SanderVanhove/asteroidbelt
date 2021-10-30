extends Area2D


func _ready() -> void:
	$AnimationPlayer.play("Float")


func _on_ExtraLife_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return

	body.add_life()
	queue_free()
