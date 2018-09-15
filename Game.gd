extends Node

func _ready():
	$Sprite.visible=true
	yield(get_tree().create_timer(.05), "timeout")
	$Sprite.visible=false
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_quit"):
		get_tree().quit()
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

