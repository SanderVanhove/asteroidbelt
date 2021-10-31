extends Node2D
class_name RandomStreamPlayer

signal finished


export(bool) var auto_play: bool = false


func _ready() -> void:
	if auto_play: play()


func play(delay: float = 0):
	yield(get_tree().create_timer(rand_range(0, delay)), "timeout")
	var random_stream: int = floor(rand_range(0, get_child_count()))

	var audioStream := get_child(random_stream)
	audioStream.play()

	yield(audioStream, "finished")

	emit_signal("finished")
