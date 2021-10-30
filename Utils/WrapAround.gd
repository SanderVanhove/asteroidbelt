extends Node


export(int, 0, 100) var margin: float = 30.0


onready var screen_size: Vector2 = get_viewport().size


func _process(delta: float) -> void:
	get_parent().position.x = wrapf(get_parent().position.x, 0 - margin, screen_size.x + margin)
	get_parent().position.y = wrapf(get_parent().position.y, 0 - margin, screen_size.y + margin)
