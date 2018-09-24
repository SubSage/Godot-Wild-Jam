extends Node2D


signal finished
signal hit


var _is_enabled = false
var _is_finished = false


func _ready():
	hide()


func start():
	_is_enabled = true
	_start_minigame()
	show()


func _process(delta):
	if !_is_enabled:
		return
	
	if _is_finished:
		_is_enabled = false
		_is_finished = false
		hide()
		emit_signal("finished")
		_finish_minigame()
	else:
		_update_minigame(delta)


#This function should be overridden in child classes
func _update_minigame(delta):
	pass


#This one should be overriden as well
func _start_minigame():
	pass


#Finally, override this too.
func _finish_minigame():
	pass