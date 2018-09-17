extends Node

func _ready():
	$Sprite.visible=true
	yield(get_tree().create_timer(.5), "timeout")
	$Sprite.visible=false 
	$ItemList.grab_focus()
	$ItemList.select(0)
	$ItemList.connect("item_selected", self, "ui_move_sound")
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_quit"):
		get_tree().quit()
	pass

func _on_ItemList_item_activated(index):
	match index:
		0:
			_option_new_game()
		1:
			_option_continue_game()
		2:
			_option_quit_game()

func _option_new_game():
	print("New game option chosen")
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _option_continue_game():
	print("Continue game option chosen")
	
	#TODO: Add game-loading code here. The call to _option_new_game should be kept as
	#a last-resort if the player choses Continue without having a save file
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _option_quit_game():
	get_tree().quit()

func ui_move_sound(index):
	$AudioStreamPlayer.play()
	pass # replace with function body
