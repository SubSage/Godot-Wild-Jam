extends "res://Scenes/Minigames/Minigame.gd"

func _ready():
	print("biting minigame initiated!")
	
	pass

func _process(delta):
	print("ending biting minigame")
	_finish_minigame()
	pass



#calling parent method (inherited)
func _finish_minigame():
	._finish_minigame()