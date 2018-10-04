extends Node2D

signal finished
signal hit

func _finish_minigame():
	emit_signal("finished")
	queue_free()