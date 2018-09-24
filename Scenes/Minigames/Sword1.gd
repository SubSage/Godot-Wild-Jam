extends "res://Scenes/Minigames/Minigame.gd"

#The scale where circle_inner matches circle_target
const threshold_outer = .39

#The scale where circle_inner matches circle_target2
const threshold_inner = .265


func _start_minigame():
	$Timer.start()


func _update_minigame(delta):
	if Input.is_key_pressed(KEY_SPACE):
		emit_signal("hit")
		_is_finished = true


func _on_Timer_timeout():
	_is_finished = true
	print("Timer called")