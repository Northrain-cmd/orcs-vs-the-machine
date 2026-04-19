extends StaticBody2D
@export var health = 1000.0
@export var max_health = 1000.0
@onready var health_bar: ProgressBar = $HealthBar
@onready var upgrade_menu: Node2D = $UpgradeMenu
@onready var label: Label = $UpgradeMenu/Panel/VBoxContainer/Label

func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = health

func request_fix_price():
	return health_bar.max_value - health_bar.value

func take_damage(amount):
	health -= amount
	health_bar.value = health
	if health <= 0:
		die()

func die():
	GameManager._set_state(GameManager.STATES.DEFEAT)

func restore_health():
	var price = health_bar.max_value - health_bar.value
	label.text = str(int(price)) + " COINS"
	if GameManager.coins >= price:
		health = health_bar.max_value
		health_bar.value = health
		GameManager.spend(price)
		GameManager.request_message("TOWER FIXED!")
		upgrade_menu.hide()
	else:
		GameManager.request_message("NOT ENOUGH COINS!")
