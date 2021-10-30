extends Node2D


var BoulderClass = preload("res://Things/Boulder/Boulder.tscn")
onready var screen_size: Vector2 = get_viewport().size

const MIN_BOULDER_TIME: float = 4.0


var large_boulder_prob: float = 1
var time: float = 0
var should_time: bool = true


onready var _boulder_timer: Timer = $BoulderTimer
onready var _death_timer: Timer = $DeathTimer

onready var _timer_label: Label = $CanvasLayer/UI/TimeLabel
onready var _end_time_label: Label = $CanvasLayer/UI/Retry/VBoxContainer/HBoxContainer/Label3
onready var _retry_screen: Control = $CanvasLayer/UI/Retry


func _ready() -> void:
	randomize()

	_on_BoulderTimer_timeout()

	_boulder_timer.start()


func _process(delta: float) -> void:
	handle_time(delta)


func handle_time(delta: float) -> void:
	if not should_time:
		return

	time += delta

	var minutes := time / 60
	var seconds := fmod(time, 60)
	_timer_label.text = "%02d:%02d" % [minutes, seconds]


func spawn_boulder(position: Vector2, is_small: bool) -> void:
	var new_boulder: Boulder = BoulderClass.instance()
	new_boulder.is_small = is_small
	new_boulder.position = position

	add_child(new_boulder)

	new_boulder.connect("cracked", self, "boulder_cracked")


func boulder_cracked(is_small: bool, position: Vector2) -> void:
	if is_small:
		return

	for i in range(randi() % 2 + 2):
		call_deferred("spawn_boulder", position, true)


func _on_BoulderTimer_timeout() -> void:
	spawn_random_boulder()

	if time > 60 and randi() % 2:
		spawn_random_boulder()
	if time > 120 and randi() % 2:
		spawn_random_boulder()

	_boulder_timer.wait_time *= .95
	if _boulder_timer.wait_time < MIN_BOULDER_TIME:
		_boulder_timer.wait_time = MIN_BOULDER_TIME

	large_boulder_prob *= .6

	printt(large_boulder_prob, _boulder_timer.wait_time)


func spawn_random_boulder() -> void:
	var x_zero: bool = bool(randi() % 2)

	var pos: Vector2

	if x_zero:
		pos = Vector2(
			-20,
			rand_range(0, screen_size.y)
		)
	else:
		pos = Vector2(
			rand_range(0, screen_size.x),
			-20
		)

	var is_small: bool = randf() < large_boulder_prob


	spawn_boulder(pos, is_small)


func _on_Player_num_lives_changed(num_lives) -> void:
	if num_lives > 0:
		return

	should_time = false
	_death_timer.start()
	_end_time_label.text = _timer_label.text


func _on_DeathTimer_timeout() -> void:
	_retry_screen.show()


func _on_Button_pressed() -> void:
	get_tree().change_scene("res://Screens/World/World.tscn")
