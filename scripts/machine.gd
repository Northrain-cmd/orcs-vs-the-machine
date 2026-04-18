extends CharacterBody2D
const BULLET = preload("uid://3slaihoisebh")

enum GunState {READY, SHOOTING, RELOADING, NOAMMO}
var current_state
@onready var shooting_point: Marker2D = $ShootingPoint
@onready var shoot_timer: Timer = $ShootTimer
@export var mag_size = 20
@export var reload_time = 3
var bullets_left = mag_size
@export var rotation_speed = 1
@export var fire_rate = 0.5
@onready var reload_timer: Timer = $ReloadTimer
@onready var ammo_label: Label = $"../UI/Control/HBoxContainer/AmmoLabel"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	shoot_timer.wait_time = fire_rate
	GameManager.machine_gun = self
	current_state = GunState.READY
	update_ammo_label()
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reload"):
		try_reloading()

func update_ammo_label():
	ammo_label.text = str(bullets_left)
	
func try_reloading():
	if current_state == GunState.RELOADING:
		return
	start_reload()
	
func start_reload():
	current_state = GunState.RELOADING
	stop_firing()
	reload_timer.wait_time = reload_time
	reload_timer.start()
	animation_player.play("Reload")
	
func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var target_angle = (mouse_pos - global_position).angle()
	rotation = lerp_angle(global_rotation, target_angle, rotation_speed)
	
func stop_firing():
	shoot_timer.stop()

func start_firing():
	if shoot_timer.is_stopped():
		shoot_timer.start()
	
func _on_shoot_timer_timeout() -> void:
	if current_state != GunState.RELOADING:
		shoot()

func shoot():
		current_state = GunState.SHOOTING
		if Input.is_action_pressed("shoot"):
			if(bullets_left == 0):
				GameManager.request_message("NO AMMO, PRESS R")
			else:
				var new_bullet = BULLET.instantiate()
				new_bullet.global_position = shooting_point.global_position
				new_bullet.global_rotation = shooting_point.global_rotation
				add_sibling(new_bullet)
				bullets_left -= 1
				update_ammo_label()

func reload():
	bullets_left = mag_size
	

func _on_reload_timer_timeout() -> void:
	finish_reloading()
	current_state = GunState.READY 

func finish_reloading():
	bullets_left = mag_size
	update_ammo_label()
	animation_player.play("RESET")
	start_firing()
