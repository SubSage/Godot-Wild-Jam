extends Node

func _ready():
	$ItemList.grab_focus()
	$ItemList.select(0)
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_quit"):
		get_tree().quit()
	pass

func _on_ItemList_item_activated(index):
	match index:
		0:
			_option_start_battle()
		1:
			_option_evolve()
		2:
			_option_save()
		3:
			_option_quit()

func _option_start_battle():
#	print("Start battle selected")
	get_tree().change_scene("res://Scenes/Battle.tscn")

func _option_evolve():
	get_tree().change_scene("res://Scenes/Upgrade.tscn")

func _option_save():
#	print("Saving not yet implimented")
	pass

func _option_quit():
	_option_save()
	get_tree().quit()

func _on_ItemList_item_selected(index):
	$AudioStreamPlayer.play()
	pass # replace with function body
