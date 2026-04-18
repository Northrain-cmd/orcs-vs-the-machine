extends Node2D
@onready var oil_rig: StaticBody2D = $".."
@onready var fix_button: Button = $Panel/VBoxContainer/HBoxContainer2/FixButton



func _ready() -> void:
	GameManager.connect("state_changed",on_state_changed)
	
func on_state_changed(new_state):
	if new_state == GameManager.STATES.VICTORY:
		fix_button.disabled = oil_rig.health >= oil_rig.max_health
		show()
		
	else:
		hide()


func _on_fix_button_pressed() -> void:
	oil_rig.restore_health()
