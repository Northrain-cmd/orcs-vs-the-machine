extends Control
@export var all_upgrades:Array[UpgradeData] = []
const UPGRADE_CARD = preload("uid://cecmffm3xii5a")
@onready var card_container: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Card_Container


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open_shop()

func open_shop():
	show()
	var available = all_upgrades.duplicate()
	available.shuffle()
	for i in range(3):
		var upgrade = available.pop_back()
		create_card(upgrade)

func create_card(data):
	var new_card = UPGRADE_CARD.instantiate()
	new_card.setup(data)
	card_container.add_child(new_card)
	
