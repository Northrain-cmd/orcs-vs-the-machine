extends StaticBody2D
@onready var health_bar: ProgressBar = $HealthBar
signal deposit_gold(amount: int)
signal destroyed
@export var health = 300.0
@export var max_health = 300.0
@onready var gold_timer: Timer = $GoldTimer
var income = 10
var gold_wait_time = 5
@onready var income_label: Label = $IncomeLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Rig
@onready var upgrade_menu: Node2D = $UpgradeMenu
@onready var label: Label = $UpgradeMenu/Panel/VBoxContainer/Label


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
	AudioManager.play_wood_sound(health, max_health)
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
	var price = int(health_bar.max_value - health_bar.value)
	label.text = str(price) + " COINS"
	if GameManager.coins >= price:
		health = health_bar.max_value
		health_bar.value = health
		GameManager.spend(price)
		GameManager.request_message("RIG FIXED!")
		upgrade_menu.hide()
	else:
		GameManager.request_message("NOT ENOUGH COINS!")

func _on_max_health_button_pressed() -> void:
	var price = health_bar.max_value - health_bar.value + 50
	if GameManager.coins >= price:
		add_max_health(1.2)
		GameManager.spend(price)
	else:
		GameManager.request_message("NOT ENOUGH COINS!")
func add_max_health(value):
	max_health *= value
	health = max_health
	health_bar.value = int(health)
	health_bar.max_value = max_health

func request_fix_price():
	return int(health_bar.max_value - health_bar.value)
	
