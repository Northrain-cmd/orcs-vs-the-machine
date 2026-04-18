extends Button

func _ready() -> void:
	GameManager.next_wave_button = self



func _on_pressed() -> void:
	GameManager.wave_number += 1
	GameManager._set_state(GameManager.STATES.SPAWNING)
