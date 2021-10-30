extends HBoxContainer


var LiveTexture: Texture = preload("res://Things/LiveTracker/live.png")


onready var _tween: Tween = $Tween


func change_lives(lives: int) -> void:
	var num_children: int = get_child_count() - 1

	if num_children < lives:
		for i in range(lives - num_children):
			var new_live: TextureRect = TextureRect.new()
			new_live.texture = LiveTexture
			add_child(new_live)
	elif num_children > lives:
		for i in range(num_children - lives):
			get_child(num_children - i).queue_free()
