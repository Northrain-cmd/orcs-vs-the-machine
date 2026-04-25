extends Control
@export var rig_price: int = 300
@onready var label: Label = $Panel/VBoxContainer/Label
var rig_location: Vector2
@onready var button: Button = $Panel/VBoxContainer/Button


func _ready():
	GameManager.connect("state_changed", on_state_changed)
	label.text = str(rig_price) + " COINS"
	button.connect("mouse_entered", _on_hover)
	
func _on_hover():
	AudioManager.play_hover()

func on_state_changed(new_state):
	if new_state == GameManager.STATES.VICTORY:
		show()
		label.text = str(rig_price) + " COINS"
	elif new_state == GameManager.STATES.SPAWNING:
		hide()

func has_enough_coins() -> bool:
	if GameManager.coins >= rig_price:
		GameManager.spend(rig_price)
		return true
	GameManager.request_message("NOT ENOUGH COINS")
	return false

func _on_button_pressed() -> void:
	if has_enough_coins():
		var oil_rig = load("uid://bf4v5u58t1ape")
		var fixed_rig = oil_rig.instantiate()
		fixed_rig.global_position = rig_location
		add_sibling(fixed_rig)
		AudioManager.play_upgrade()
		GameManager.operational_rigs += 1
		queue_free()
	
