extends AudioStreamPlayer2D
var num_players = 8
var sfx_bus = "SFX"
var available = []
var queue = []

const combat_track = preload("uid://w8pxwx0ali1g")
const upgrade_track = preload("uid://bsumfoddgmamc")
const game_over_track = preload("uid://die3cm4pugtok")
var mute_button: Button
@onready var current_state = GameManager.current_state
const muted_icon = preload("uid://csupipwc3b5nw")
const unmuted_icon = preload("uid://c3pn5dklaoama")
var is_muted:bool = false
var sounds = {
	"impacts": {
		"stone": {
			"light": ["uid://cb6ekfctnvel8","uid://dl661jdepaxdq","uid://shxdhp7p2702","uid://ni6b1spmyj3q","uid://cr333irin8m67","uid://inatw6u3x1dx","uid://bocaesjb3vkyk","uid://c4u1yghueq5q7","uid://cunyxbpimj4ms"],
			"medium": ["uid://ds7rs1pkmo1f1","uid://o8ohx50ythtl","uid://lqxlkyqb0ltw","uid://buq0rk3oyccqr","uid://dn4bhd4kjfyp7","uid://bccgivophb3jj","uid://cophb5bsnuvnf","uid://b331ole1h6js3","uid://dqhmfj75nitq0","uid://cx07fwuikbwej","uid://ccj1tj6vidrci"],
			"heavy": ["uid://dpbmwwd2e304d","uid://bejj1sifjlxed","uid://beivpo6tkx3hb","uid://yw5ghrkcvhxx","uid://bb5r08nxwhcbq","uid://c65yikbl1kf1p","uid://bg4io8fjp7h18","uid://ceunijkiow3dn","uid://b51e1w0b1lixh"],
			"shatter": ["uid://c3ah2wu5ol8e"]
		},
		"wood": {
			"light": ["uid://bhcqd25q7e38d","uid://u8f37l4rv0bo","uid://b3se20hhsyndg","uid://cegn1i6gx1yxg","uid://ycnr7k7wygdj","uid://uh1gn1seo0ut","uid://d3lohyvm6pyax","uid://j82if44cv6tq","uid://c1iosvd707j4w","uid://dyggqp2d4afme"],
			"medium": ["uid://cwi77b5p700rp","uid://d2ovxmgk1yd0k","uid://b75os7ffe3ktb","uid://n8wusw4yd4xp","uid://d0q4mi2rj1el6","uid://qmew3hsnmdle","uid://dymu8lyhpglo4","uid://crdk3qy0qcn2i","uid://cw68nkg2yy8v8"],
			"heavy": ["uid://ddh31uchaug5y","uid://dasfy6oq3risj","uid://bsd6fprtpvo7v","uid://csg4nbti8mco8","uid://ws1ww2yhehqp","uid://dskni5hcch54c","uid://qivw1fugmn03","uid://c321hnqv218x","uid://ieilhqqkgbf1","uid://bp15cblhxhejy"],
			"shatter": ["uid://bsb5doxycd3st"]
		},
	},
	"menu": {
		"coins":["uid://dvhwnurh18j8n","uid://be3s1tai7ythq"]
	}
}
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	current_state = GameManager.STATES.START
	stream = upgrade_track
	bus = "Master"
	volume_db = -10
	play()
	GameManager.state_changed.connect(on_state_change)
	for i in num_players:
		var player = AudioStreamPlayer.new()
		player.bus = sfx_bus
		player.volume_db = -14
		add_child(player)
		available.append(player)
		player.finished.connect(_on_stream_finished.bind(player))
		
func play_wood_sound(health, max_health):
	if health / max_health >= 0.66:
		queue.append(sounds["impacts"]["wood"]["light"].pick_random())
	elif health / max_health >= 0.33:
		queue.append(sounds["impacts"]["wood"]["medium"].pick_random())
	elif health / max_health >= 0.001:
		queue.append(sounds["impacts"]["wood"]["heavy"].pick_random())
	elif health <= 0:
		queue.append(sounds["impacts"]["wood"]["shatter"].pick_random())
	
func play_stone_sound(health, max_health):
	if health / max_health >= 0.66:
		queue.append(sounds["impacts"]["stone"]["light"].pick_random())
	elif health / max_health >= 0.33:
		queue.append(sounds["impacts"]["stone"]["medium"].pick_random())
	elif health / max_health >= 0.001:
		queue.append(sounds["impacts"]["stone"]["heavy"].pick_random())
	elif health <= 0:
		queue.append(sounds["impacts"]["stone"]["shatter"].pick_random())
func play_coin_sound():
	queue.append(sounds["menu"]["coins"].pick_random())

func _process(delta: float) -> void:
	if not queue.is_empty() and not available.is_empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()
func _on_stream_finished(stream):
	available.append(stream)
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
			print(is_playing())
		GameManager.STATES.START:
			stream = upgrade_track
			play()

func set_mute_button(button):
	mute_button = button
	mute_button.connect("pressed", _on_mute_button_pressed)

func _on_mute_button_pressed() -> void:
	if(not is_muted):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)
		mute_button.icon = muted_icon
		is_muted = true
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
		is_muted = false
		mute_button.icon = unmuted_icon
