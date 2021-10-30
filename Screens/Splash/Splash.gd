extends Node2D


onready var logo: TextureRect = $Control/CenterContainer/TextureRect
onready var tween: Tween = $Tween


func _ready():
	if not OS.is_debug_build():
		tween.interpolate_property(logo, "modulate:a", 0, 1, .5, Tween.TRANS_SINE, Tween.EASE_OUT_IN)
		tween.interpolate_property(logo, "modulate:a", 1, 0, .5, Tween.TRANS_SINE, Tween.EASE_OUT_IN, 1.5)
		tween.start()

		yield(tween, "tween_all_completed")
	get_tree().change_scene("res://Screens/World/World.tscn")
