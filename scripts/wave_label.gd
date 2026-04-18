extends Label
var current_state
func _ready() -> void:
	GameManager.connect("state_changed",_on_state_change)
	current_state = GameManager.STATES.START

func _on_state_change(new_state):
	current_state = new_state
	text = "WAVE   " + str(GameManager.wave_number)
