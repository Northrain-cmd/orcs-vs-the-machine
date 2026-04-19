extends Node2D
@export  var fix_object: StaticBody2D
@onready var fix_button: Button = $Panel/VBoxContainer/FixButton
@onready var label: Label = $Panel/VBoxContainer/Label




func _ready() -> void:
	GameManager.connect("state_changed",on_state_changed)
	
func on_state_changed(new_state):
	if new_state == GameManager.STATES.VICTORY:
		visible = fix_object.health < fix_object.max_health
		label.text = str(int(fix_object.request_fix_price())) + " COINS"
	elif new_state == GameManager.STATES.SPAWNING:
		hide()
func _on_fix_button_pressed() -> void:
	fix_object.restore_health()
