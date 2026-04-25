extends MarginContainer
@onready var button: Button = $VBoxContainer/MarginContainer/HBoxContainer/Button

var local_data: UpgradeData

func setup(data:UpgradeData) -> void:
	local_data = data
	var sb = StyleBoxTexture.new()
	var title: Label = $VBoxContainer/Name
	var desc: Label = $VBoxContainer/Desc
	var panel_container: PanelContainer = $PanelContainer
	sb.texture = data.icon
	title.text = data.title
	desc.text = data.description
	var price_label: Label = $VBoxContainer/MarginContainer/HBoxContainer/PanelContainer/Label
	price_label.text = str(data.price)
	panel_container.add_theme_stylebox_override("panel",sb)

func _ready() -> void:
	button.connect("mouse_entered", _on_hover)
	button.connect("pressed", _on_pressed)

func _on_hover():
	AudioManager.play_hover()
	
func _on_pressed():
	AudioManager.play_upgrade()
	
func _on_buy_button_pressed(btn: Button) -> void:
	if GameManager.coins >= local_data.price:
		GameManager.spend(local_data.price)
		GameManager.apply_upgrade(local_data.effect_type,local_data.value)
		btn.disabled = true
	else:
		GameManager.request_message("NOT ENOUGH COINS")
		
