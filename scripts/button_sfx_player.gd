extends Node

func _on_hover():
	AudioManager.play_hover()

func _on_click():
	AudioManager.play_confirm()
	
func _ready() -> void:
	var button = get_parent()
	button.connect("mouse_entered",_on_hover)
	button.connect("pressed",_on_click)
	
