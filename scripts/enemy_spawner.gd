extends Node2D
@onready var timer: Timer = $Timer

@export var golden_chance = 0.1
@export var reward = 30

const BASIC_ORC = preload("uid://cdj0av7ordtdf")
const enemy_types = {
	"basic": preload("uid://cdj0av7ordtdf"),
	"tank": preload("uid://dymdmgcwlck6q"),
	"fast": preload("uid://dsq2k7kmyh55t")
}
var current_wave
var enemies_to_spawn = []
var waves_table = [
	{
	"enemies": [
		{"type": "basic", "count": 10},
	],
	"delay": 2
	},
	{
	"enemies": [
	{"type": "basic", "count": 10},
	{"type": "tank", "count": 3},
	],
	"delay": 1.9
	},
{
	"enemies": [
		{"type": "basic", "count": 10},
		{"type": "tank", "count": 2},
		{"type": "fast", "count": 5},
	],
	"delay": 1.8
	},
{
	"enemies": [
		{"type": "basic", "count": 15},
		{"type": "tank", "count": 3},
		{"type": "fast", "count": 6},
	],
	"delay": 1.7
	},
{
	"enemies": [
		{"type": "basic", "count": 15},
		{"type": "tank", "count": 5},
		{"type": "fast", "count": 5},
	],
	"delay": 1.6
	},
{
	"enemies": [
		{"type": "basic", "count": 17},
		{"type": "tank", "count": 5},
		{"type": "fast", "count": 10},
	],
	"delay": 1.5
	},
{
	"enemies": [
		{"type": "basic", "count": 20},
		{"type": "tank", "count": 8},
		{"type": "fast", "count": 10},
	],
	"delay": 1.4
	},
{
	"enemies": [
		{"type": "basic", "count": 25},
		{"type": "tank", "count": 10},
		{"type": "fast", "count": 10},
	],
	"delay": 1.3
	},
	{
	"enemies": [
		{"type": "basic", "count": 30},
		{"type": "tank", "count": 15},
		{"type": "fast", "count": 15},
	],
	"delay": 1.2
	},
	{
	"enemies": [
		{"type": "basic", "count": 35},
		{"type": "tank", "count": 20},
		{"type": "fast", "count": 20},
	],
	"delay": 1.0
	},
]


func _ready() -> void:
	GameManager.enemy_spawner = self
func start_spawning(wave_number):
	if(wave_number > waves_table.size()):
		add_wave(current_wave)
	enemies_to_spawn = []
	current_wave = GameManager.wave_number - 1
	timer.wait_time = waves_table[current_wave].delay
	for enemy_type in waves_table[current_wave].enemies:
		var cur_enemy = enemy_type.type
		for n in enemy_type.count:
			enemies_to_spawn.push_back(cur_enemy)
	enemies_to_spawn.shuffle()
	if timer.is_stopped():
		timer.start()

func add_wave(current_wave):
	var new_index = current_wave + 1
	var previous_wave = waves_table[current_wave]
	var new_wave = previous_wave.duplicate()
	var new_timer_wait_time = waves_table[current_wave].delay - 0.1
	if new_timer_wait_time <= 0:
		new_timer_wait_time = 0
	new_wave["delay"] = new_timer_wait_time
	new_wave["enemies"][0]["count"] += 5
	new_wave["enemies"][1]["count"]+= 2
	new_wave["enemies"][2]["count"]+= 3
	waves_table.push_back(new_wave)

func spawn_enemy(type):
	var new_enemy = enemy_types[type].instantiate()
	new_enemy.target = get_tree().get_nodes_in_group("bases").pick_random()
	new_enemy.golden_chance = golden_chance
	new_enemy.reward = reward
	new_enemy.global_position = get_tree().get_nodes_in_group("spawn_markers").pick_random().global_position
	add_sibling(new_enemy)


func _on_timer_timeout() -> void:
	if not enemies_to_spawn.is_empty():
		var next_enemy = enemies_to_spawn.pop_back()
		spawn_enemy(next_enemy)
	else:
		GameManager._set_state(GameManager.STATES.COMBAT)
		timer.stop()

func increase_golden_chance(value):
	golden_chance += value
	
func increase_golden_reward(value):
	reward += value
