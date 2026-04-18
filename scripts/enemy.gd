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

var is_stopped = false
var current_target
var target_position
func _ready() -> void:
	timer.wait_time = attack_rate
	target_position = target.global_position + Vector2(0, randf_range(-50,50))
	animation_player.play("Run")
	if target.has_signal("destroyed"):
		target.connect("destroyed",on_target_destroy)
	
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

func _take_damage(amount,bullet):
	var tween = create_tween()
	tween.tween_property(sprite_2d, "modulate",Color.RED, 0.1)
	tween.tween_property(sprite_2d, "scale",Vector2(0.9,0.9), 0.1)
	tween.tween_property(sprite_2d, "modulate",Color.WHITE, 0.1)
	tween.tween_property(sprite_2d, "scale",Vector2(1,1), 0.1)	
	health -= amount
	if health <= 0:
		die()
func on_target_destroy():
	target = tower
	target_position = target.global_position + Vector2(0, randf_range(-50,50))

func die():
	var effect = DEATH_EFFECT.instantiate()
	effect.global_position = global_position
	add_sibling(effect)
	queue_free()
