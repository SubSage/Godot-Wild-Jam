extends Node2D


signal finished
signal hit


var _is_enabled = false
var _is_finished = false


func start():
	_is_enabled = true


func _process(delta):
	if !_is_enabled:
		return
	
	if _is_finished:
		_is_enabled = false
		_is_finished = false
		emit_signal("finished")
	else:
		_update_minigame(delta)


#This function should be overridden in child classes
func _update_minigame(delta):
	pass