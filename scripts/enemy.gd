extends RigidBody2D
@export var target: StaticBody2D
@onready var tower: StaticBody2D = $"../Tower"
@export var speed = 100
@export var health = 100.0
@export var attack_rate = 1
@export var attack_power = 30
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

const DEATH_EFFECT = preload("uid://tfv6ois8vjej")
const GOLD_EFFECT = preload("uid://betbx5qryparw")

@onready var crit_label: Label = $CritLabel
var golden_chance: float
var reward: int
@export var enemy_type = "basic"
const gold_outline = preload("uid://qvyo7xfbutsq")

var is_golden = false

var is_stopped = false
var current_target
var target_position
func _ready() -> void:
	GameManager.basic_enemy = self
	if randf() <= golden_chance:
		make_golden()
	timer.wait_time = attack_rate
	target_position = target.global_position + Vector2(0, randf_range(-50,50))
	animation_player.play("Run")
	if target.has_signal("destroyed"):
		target.connect("destroyed",on_target_destroy)
	
func make_golden():
	is_golden = true
	sprite_2d.material = gold_outline
	
func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(target_position)
	if not is_stopped:
		linear_velocity = direction * delta * speed
		move_and_collide(linear_velocity)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.has_method("take_damage")):
		_stop_animation()
		is_stopped = true
		current_target = body
		body.take_damage(attack_power)
		timer.start()
		
func _stop_animation():
		if animation_player.has_animation("Attack"):
			animation_player.play("Attack")
		else:
			animation_player.play("RESET")

func _on_timer_timeout() -> void:
	if current_target:
		current_target.take_damage(attack_power)
	
	else:
		is_stopped = false
		on_target_destroy()

func _take_damage(amount,bullet, is_crit):
	if is_crit:
		show_crit()
	var tween = create_tween()
	tween.tween_property(sprite_2d, "modulate",Color.RED, 0.1)
	tween.tween_property(sprite_2d, "scale",Vector2(0.9,0.9), 0.1)
	tween.tween_property(sprite_2d, "modulate",Color.WHITE, 0.1)
	tween.tween_property(sprite_2d, "scale",Vector2(1,1), 0.1)	
	health -= amount
	AudioManager.play_creature_sound("hit", enemy_type)
	if health <= 0:
		die()
func on_target_destroy():
	target = tower
	target_position = target.global_position + Vector2(0, randf_range(-50,50))

func die():
	AudioManager.play_creature_sound("die", enemy_type)
	var effect = null
	if is_golden == true:
		GameManager.earn(reward)
		effect =  GOLD_EFFECT.instantiate()
		AudioManager.play_coin_sound()
	elif is_golden == false:
		effect = DEATH_EFFECT.instantiate()
	effect.global_position = global_position
	add_sibling(effect)
	queue_free()

func increase_golden_chance(amount):
	golden_chance += amount

func increase_golden_reward(amount):
	reward += amount

func show_crit():
	crit_label.modulate.a = 1.0
	crit_label.scale = Vector2.ZERO
	crit_label.show()
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	
	# 1. Анимация прыжка вверх
	tween.tween_property(crit_label, "position:y", crit_label.position.y - 50, 0.4)\
		.set_ease(Tween.EASE_OUT)
	
	# 2. Небольшой разброс по горизонтали (влево-вправо)
	var random_x = randf_range(-10, 10)
	tween.tween_property(crit_label, "position:x", crit_label.position.x + random_x, 0.4)

	# 3. Эффект "удара" (увеличение масштаба)
	tween.tween_property(crit_label, "scale", Vector2(1.5, 1.5), 0.15)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	# Переходим к последовательной анимации (исчезновение после прыжка)
	tween.set_parallel(false)
	
	# 4. Пауза, чтобы игрок успел прочитать число
	tween.tween_interval(0.2)
	
	# 5. Плавное исчезновение
	tween.tween_property(crit_label, "modulate:a", 0.0, 0.3)
