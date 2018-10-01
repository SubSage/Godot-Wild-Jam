extends Node

var Menu = preload("res://Scenes/MainMenu.tscn")


func _ready():
	randomize()
	$Sprite.visible=true
	yield(get_tree().create_timer(2), "timeout")
	$Sprite.visible=false 
	$ItemList.grab_focus()
	$ItemList.select(0)
	$ItemList.connect("item_selected", self, "ui_move_sound")
	pass


func _process(delta):
	if Input.is_action_just_pressed("ui_quit"):
		get_tree().quit()


func _on_ItemList_item_activated(index):
	match $ItemList.get_item_text(index):
		"New Game":
			_option_new_game()
		"Continue":
			_option_continue_game()
		"Quit":
			_option_quit_game()


func _option_new_game():
	var menu = Menu.instance()
	add_child(menu)
	$ItemList.queue_free()


func _option_continue_game():
	#TODO: Add game-loading code here. The call to _option_new_game should be kept as
	#a last-resort if the player choses Continue without having a save file
	_option_new_game()


func _option_quit_game():
	get_tree().quit()


func ui_move_sound(index):
	$AudioStreamPlayer.play()

