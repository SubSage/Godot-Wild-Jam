extends Node


func _process(delta):
	if Input.is_action_just_pressed("ui_quit"):
		get_tree().quit()


func _on_ActionList_action_chosen(action):
	print(action)
