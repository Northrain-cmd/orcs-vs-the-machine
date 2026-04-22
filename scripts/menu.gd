extends Control
@onready var credits_button: Button = $MarginContainer/VBoxContainer/CreditsButton
@onready var animation_player: AnimationPlayer = $CreditsController/AnimationPlayer

func _ready() -> void:
	animation_player.play("Reset")
	GameManager.menu = self
	
func _on_credits_button_pressed() -> void:
	credits_button.modulate.a = 0
	animation_player.play("show_credits")


func _on_play_button_pressed() -> void:
	animation_player.play("Reset")
	GameManager._set_state(GameManager.STATES.START)
	hide()
