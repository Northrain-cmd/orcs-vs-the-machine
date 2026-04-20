extends Area2D
var _SPEED = 300.0
var _damage = 50.0
var max_distance: float
var start_position:Vector2
var has_hit = false
var _is_crit = false

func _ready() -> void:
	start_position = global_position
	
func setup(distance:float, damage:float, speed:float, is_crit:bool):
	max_distance = distance
	_damage = damage
	_SPEED = speed
	_is_crit = is_crit
	
func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(global_rotation)
	position += direction  * _SPEED * delta
	if position.distance_to(start_position) > max_distance:
		queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if(not has_hit and body.has_method("_take_damage")):
		has_hit = true
		body._take_damage(_damage,self,_is_crit)
		queue_free()
