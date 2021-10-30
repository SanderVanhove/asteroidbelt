extends KinematicBody2D

signal num_lives_changed(num_lives)


const BulletClass = preload("res://Things/Bullet/Bullet.tscn")


const TURN_SPEED: float = 5.0
const ACCELETATION: float = 600.0
const MAX_SPEED: float = 250.0
const NORMAL_COLOR: Color = Color("00D5FF")
const TURBO_COLOR: Color = Color("F460FF")


var _movement: Vector2 = Vector2.ZERO
var _num_lives: int = 3


onready var _fire_point: Node2D = $FirePoint
onready var _truster_sprite: Sprite = $Visual/TrusterSprite
onready var _tween: Tween = $Tween
onready var _truster_flare_tween: Tween = $TrusterFlareTween
onready var _truster_particles: CPUParticles2D = $TrusterParticles
onready var _visuals: Node2D = $Visual
onready var _fire_timer: Timer = $FireTimer
onready var _wrap_around = $WrapAround
onready var _ultra_timer: Timer = $UltraTimer
onready var _ship_sprite: Sprite = $Visual/Sprite


func _ready() -> void:
	_truster_sprite.modulate.a = 0
	_truster_sprite.scale.y = 0
	_ship_sprite.modulate = NORMAL_COLOR


func _process(delta: float) -> void:
	handle_turning(delta)
	handle_trust(delta)
	handle_firing()
	handle_super_power()


func handle_super_power() -> void:
	if not Input.is_action_just_pressed("ultra_power") or _num_lives <= 1:
		return

	_ultra_timer.start()

	_num_lives -= 1
	emit_signal("num_lives_changed", _num_lives)

	_fire_timer.wait_time = .1

	_tween.interpolate_property(_ship_sprite, "modulate", _ship_sprite.modulate, TURBO_COLOR, .2)
	_tween.start()


func handle_turning(delta: float) -> void:
	var turn_speed: float = 0

	if Input.is_action_pressed("ui_left"):
		turn_speed = -TURN_SPEED
	if Input.is_action_pressed("ui_right"):
		turn_speed = TURN_SPEED

	if not turn_speed:
		return

	self.rotation += turn_speed * delta


func handle_trust(delta: float) -> void:
	var acceleration: float = 0

	if Input.is_action_pressed("ui_up"):
		acceleration = -ACCELETATION
	if Input.is_action_pressed("ui_down"):
		acceleration = ACCELETATION

	_movement += Vector2(0, acceleration * delta).rotated(rotation)
	_movement = _movement.clamped(MAX_SPEED)

	_movement = move_and_slide(_movement)

	handle_truster_animation()


func handle_truster_animation() -> void:
	var time: float = .3
	if Input.is_action_just_pressed("ui_up"):
		_tween.interpolate_property(_truster_sprite, "modulate:a", _truster_sprite.modulate.a, 1, time)
		_tween.interpolate_property(_truster_sprite, "scale:y", _truster_sprite.scale.y, 1, time)
		_tween.start()

		_truster_particles.emitting = true

		yield(get_tree().create_timer(time), "timeout")

		if not Input.is_action_pressed("ui_up"):
			return
		_truster_flare_tween.interpolate_property(_truster_sprite, "scale:y", .8, 1.1, .2)
		_truster_flare_tween.repeat = true
		_truster_flare_tween.start()
	elif Input.is_action_just_released("ui_up"):
		_truster_flare_tween.remove_all()

		_tween.interpolate_property(_truster_sprite, "modulate:a", _truster_sprite.modulate.a, 0, time)
		_tween.interpolate_property(_truster_sprite, "scale:y", _truster_sprite.scale.y, 0, time)
		_tween.start()

		_truster_particles.emitting = false


func handle_firing() -> void:
	if not Input.is_action_just_pressed("fire"):
		return

	fire()
	_fire_timer.start()


func fire() -> void:
	spawn_bullet(0)

	if not _ultra_timer.is_stopped():
		spawn_bullet(PI/4)
		spawn_bullet(-PI/4)

	_tween.interpolate_property(_visuals, "scale", _visuals.scale, Vector2(.8, .8), .05)
	_tween.interpolate_property(_visuals, "scale", Vector2(.8, .8), Vector2.ONE, .4, Tween.TRANS_SINE, Tween.EASE_OUT, .05)
	_tween.start()


func spawn_bullet(angle: float) -> void:
	var bullet: Bullet = BulletClass.instance()
	bullet.global_transform = _fire_point.global_transform
	bullet.rotate(angle)
	get_parent().add_child(bullet)


func hit(hitting_object) -> void:
	if not _ultra_timer.is_stopped():
		return

	_num_lives -= 1
	_movement += (position - hitting_object.position) * 50


	emit_signal("num_lives_changed", _num_lives)
	print("Lives: ", _num_lives)


func _on_FireTimer_timeout() -> void:
	if not Input.is_action_pressed("fire"):
		return

	fire()
	_fire_timer.start()


func _on_UltraTimer_timeout() -> void:
	_fire_timer.wait_time = .3
	_tween.interpolate_property(_ship_sprite, "modulate", _ship_sprite.modulate, NORMAL_COLOR, .2)
	_tween.start()
