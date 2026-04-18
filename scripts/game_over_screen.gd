extends Control
var current_state
func _ready() -> void:
	GameManager.connect("state_changed", on_state_changed)
	current_state = GameManager.STATES.START
	
func on_state_changed(new_state):
	current_state = new_state
	match current_state:
		GameManager.STATES.START:
			hide()
		GameManager.STATES.DEFEAT:
			show()



func _on_button_pressed() -> void:
	GameManager._set_state(GameManager.STATES.START)
	get_tree().reload_current_scene()
