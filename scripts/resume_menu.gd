extends MarginContainer


func _ready() -> void:
	GameManager.resume_menu = self
	
func _on_resume_button_pressed() -> void:
	GameManager.unpause_game()
	hide()


func _on_exit_button_pressed() -> void:
	GameManager.exit_to_menu()
	hide()
