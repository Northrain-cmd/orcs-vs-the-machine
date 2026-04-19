extends AudioStreamPlayer2D
const combat_track = preload("uid://cyvw7hbhkoq6x")
const upgrade_track = preload("uid://bhxqm48cabemm")
const game_over_track = preload("uid://bi03f2nv6hijf")
var mute_button: Button
@onready var current_state = GameManager.current_state
const muted_icon = preload("uid://csupipwc3b5nw")
const unmuted_icon = preload("uid://c3pn5dklaoama")
var is_muted:bool = false

func _ready() -> void:
	current_state = GameManager.STATES.START
	stream = upgrade_track
	play()
	GameManager.state_changed.connect(on_state_change)
func on_state_change(new_state):
	current_state = new_state
	match current_state:
		GameManager.STATES.SPAWNING:
			stream = combat_track
			play()
		GameManager.STATES.COMBAT:
			pass
		GameManager.STATES.VICTORY:
			stream = upgrade_track
			play()
		GameManager.STATES.DEFEAT:
			stream = game_over_track
			play()
		GameManager.STATES.START:
			stream = upgrade_track
			play()

func set_mute_button(button):
	mute_button = button
	mute_button.connect("pressed", _on_mute_button_pressed)

func _on_mute_button_pressed() -> void:
	if(not is_muted):
		volume_db = -80
		mute_button.icon = muted_icon
		is_muted = true
	else:
		volume_db = 0
		is_muted = false
		mute_button.icon = unmuted_icon
