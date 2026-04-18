extends StaticBody2D
@onready var health_bar: ProgressBar = $HealthBar
signal deposit_gold(amount: int)
signal destroyed
@export var health = 300.0
@export var max_health = 300.0
@onready var gold_timer: Timer = $GoldTimer
var income = 5
var gold_wait_time = 5
@onready var income_label: Label = $IncomeLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Rig


func _ready() -> void:
	gold_timer.wait_time = gold_wait_time
	deposit_gold.connect(GameManager.on_gold_deposit)
	health_bar.max_value = max_health
	health_bar.value = health
	GameManager.state_changed.connect(on_game_state_changed)
	income_label.text = "+" + str(income)
	if GameManager.current_state == GameManager.STATES.SPAWNING:
		start_mining()
	
func on_game_state_changed(new_state):
	match new_state:
		GameManager.STATES.SPAWNING:
			start_mining()
		GameManager.STATES.COMBAT:
			pass
		_:
			stop_mining()
	
	
func take_damage(amount):
	var tween = create_tween()
	tween.tween_property(sprite_2d, "modulate",Color.RED, 0.1)
	tween.tween_property(sprite_2d, "modulate",Color.WHITE, 0.1)
	health -= amount
	health_bar.value = health
	if health <= 0:
		die()

func die():
	destroyed.emit()
	queue_free()

func stop_mining():
	gold_timer.stop()
	
func start_mining():
	gold_timer.start()

func _on_gold_timer_timeout() -> void:
	deposit_gold.emit(income)
	animation_player.play("Gold_Deposited")
	
func restore_health():
	var price = health_bar.max_value - health_bar.value
	if GameManager.coins >= price:
		health = health_bar.max_value
		health_bar.value = health
		GameManager.spend(price)
	else:
		GameManager.request_message("NOT ENOUGH COINS!")
