extends MarginContainer
@onready var label: Label = $PanelContainer/MarginContainer/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func display(text:String):
	label.text = text
	animation_player.play("show_message")
	
func _ready() -> void:
	GameManager.message_label = self
