extends CharacterBody2D
const BULLET = preload("uid://3slaihoisebh")

enum GunState {READY, SHOOTING, RELOADING, NOAMMO}
var current_state
var game_state
@onready var shooting_point: Marker2D = $ShootingPoint
@onready var shoot_timer: Timer = $ShootTimer
@onready var scope: Line2D = $Line2D
@export var mag_size = 30
@export var reload_time = 2
@export var bullet_speed = 300.0
@export var bullet_damage = 50.0
@export var crit_chance = 0.05
@export var crit_damage_multiplier = 1.5
var bullets_left = mag_size
@export var rotation_speed = 0.012
@export var fire_rate = 0.5
@export var max_range = 600.0
var is_crit = false
@onready var reload_timer: Timer = $ReloadTimer
@onready var ammo_label: Label = $"../UI/Control/HBoxContainer/AmmoLabel"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	scope.hide()
	ammo_label.text = str(mag_size)
	shoot_timer.wait_time = fire_rate
	GameManager.machine_gun = self
	GameManager.connect("state_changed", on_game_state_changed)
	game_state = GameManager.current_state
	current_state = GunState.READY
	update_ammo_label()
	scope.set_point_position(1, Vector2(scope.position.x + max_range,0))

func on_game_state_changed(new_state):
	game_state = new_state
	match game_state:
		GameManager.STATES.START, GameManager.STATES.VICTORY:
			scope.hide()
		_:
			scope.show()
	

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reload"):
		try_reloading()
func update_ammo_label():
	ammo_label.text = str(int(bullets_left))

func reduce_reload_time(value:float):
	reload_time *= value
	print(str(reload_time))
	
func increase_range(value:float):
	max_range *= value
	scope.set_point_position(1, Vector2(scope.position.x + max_range,0))
	print(str(max_range))

func increase_mag_size(value):
	mag_size += value
	bullets_left = mag_size
	update_ammo_label()

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

func handle_game_state():
	match game_state:
		GameManager.STATES.SPAWNING, GameManager.STATES.COMBAT:
			var mouse_pos = get_global_mouse_position()
			var target_angle = (mouse_pos - global_position).angle()
			rotation = lerp_angle(global_rotation, target_angle, rotation_speed)
			var scope_end_pos = mouse_pos.x
			if scope_end_pos > max_range:
				scope_end_pos = max_range
			scope.set_point_position(1, Vector2(scope_end_pos,0))
		_:
			pass
			
func _physics_process(delta: float) -> void:
	handle_game_state()
		
		
	
func stop_firing():
	shoot_timer.stop()
	

func start_firing():
	if Input.is_action_just_pressed("shoot") and current_state != GunState.RELOADING:
		shoot()
	elif Input.is_action_pressed("shoot"):
		if shoot_timer.is_stopped():
			shoot_timer.start()
	elif Input.is_action_just_released("shoot"):
		shoot_timer.stop()
		
func _on_shoot_timer_timeout() -> void:
	if current_state != GunState.RELOADING:
		shoot()

func shoot():
	if(bullets_left == 0):
		GameManager.request_message("NO AMMO, PRESS R")
	else:
		var cur_damage = calc_damage()
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = shooting_point.global_position
		new_bullet.global_rotation = shooting_point.global_rotation
		new_bullet.setup(max_range, cur_damage, bullet_speed, is_crit)
		add_sibling(new_bullet)
		bullets_left -= 1
		update_ammo_label()
func calc_damage():
	if randf() <= crit_chance:
		is_crit = true
		return bullet_damage * crit_damage_multiplier
	else: return bullet_damage
func reload():
	bullets_left = mag_size
	

func _on_reload_timer_timeout() -> void:
	finish_reloading()
	current_state = GunState.READY 

func finish_reloading():
	bullets_left = mag_size
	update_ammo_label()
	animation_player.play("RESET")

func increase_bullet_speed(value):
	bullet_speed *= value
	print(str(bullet_speed))
	
func increase_bullet_damage(value):
	bullet_damage *= value
	print(bullet_damage)
	
func increase_crit_chance(value):
	crit_chance += value
	print(crit_chance)
	
func increase_crit_damage(value):
	crit_damage_multiplier *= value
	print(crit_damage_multiplier)
	
func increase_rotation_speed(value):
	rotation_speed *= value
	print(rotation_speed)
