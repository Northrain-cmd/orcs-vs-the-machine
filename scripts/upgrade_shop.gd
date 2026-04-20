extends Control
@export var _all_upgrades:Array[UpgradeData] = []
const UPGRADE_CARD = preload("uid://cecmffm3xii5a")
@onready var card_container: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Card_Container


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#open_shop()
	GameManager.upgrade_shop = self
	GameManager.connect("state_changed", on_state_change)


func on_state_change(new_state):
	match new_state:
		GameManager.STATES.VICTORY:
			open_shop()
		_:
			_on_done_button_pressed()

func open_shop():
	show()
	var available = _all_upgrades.duplicate()
	available.shuffle()
	for i in range(3):
		var upgrade = available.pop_back()
		create_card(upgrade)

func create_card(data):
	var new_card = UPGRADE_CARD.instantiate()
	new_card.setup(data)
	card_container.add_child(new_card)
	


func _on_done_button_pressed() -> void:
	hide()
	for child in card_container.get_children():
		card_container.remove_child(child)
