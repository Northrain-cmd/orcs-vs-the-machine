extends Node
var enemy_spawner = null
var coins_label = null
var next_wave_button = null
var machine_gun = null
var _spawn_started = false
var message_label = null
var coins: int = 0
signal state_changed(new_state)

enum STATES {
	START,
	SPAWNING,
	COMBAT,
	VICTORY,
	DEFEAT
	}
	
var current_state:STATES = STATES.START
const BASIC_ORC = preload("uid://cdj0av7ordtdf")
var wave_number

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	handle_state(delta)

func handle_state(delta):
	match current_state:
		STATES.START:
			coins = 0
			wave_number = 0
			machine_gun.stop_firing()
			next_wave_button.show()
		STATES.SPAWNING:
			next_wave_button.hide()
			machine_gun.start_firing()
			if _spawn_started == false:
				enemy_spawner.start_spawning(wave_number)
				_spawn_started = true
		STATES.COMBAT:
			if get_tree().get_nodes_in_group("enemies").size() == 0:
				_set_state(STATES.VICTORY)
		STATES.VICTORY:
			_spawn_started = false
			next_wave_button.show()
			machine_gun.stop_firing()
		STATES.DEFEAT:
			_spawn_started = false
			machine_gun.stop_firing()
			get_tree().paused = true

func _set_state(new_state:STATES):
	if(new_state == STATES.START and get_tree().paused == true):
		get_tree().paused = false
	if current_state == new_state:
		return
	current_state = new_state
	state_changed.emit(current_state)
	
func on_gold_deposit(income):
	coins += income
	coins_label.text = str(coins)
	
func spend(price):
	if price <= coins:
		coins -= price
		coins_label.text = str(coins)
		
func request_message(text:String):
	message_label.display(text)
