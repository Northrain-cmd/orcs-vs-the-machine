extends Label
var current_state
func _ready() -> void:
	GameManager.connect("state_changed",_on_state_change)

func _on_state_change(new_state):
	print(GameManager.wave_number)
	text = "WAVE   " + str(GameManager.wave_number)
