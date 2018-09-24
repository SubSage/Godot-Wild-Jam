extends "res://Scenes/Minigames/Minigame.gd"


func _update_minigame():
	$Timer.start()
	
	if Input.is_key_pressed(KEY_SPACE):
		emit_signal("hit")
		_is_finished = true


func _on_Timer_timeout():
	_is_finished = true
