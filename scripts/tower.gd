extends StaticBody2D
@export var health = 1000.0
@onready var health_bar: ProgressBar = $HealthBar

func _ready() -> void:
	health_bar.max_value = health
	health_bar.value = health
	
func take_damage(amount):
	health -= amount
	health_bar.value = health
	if health <= 0:
		die()

func die():
	GameManager._set_state(GameManager.STATES.DEFEAT)
