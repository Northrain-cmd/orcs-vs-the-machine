extends CPUParticles2D

func _on_ready() -> void:
	emitting = true
	print("I emitted")


func _on_finished() -> void:
	queue_free()
