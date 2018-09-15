extends Control
var actions = {attack1 = "attack1", attack2 = "attack2", defense = "defend"
		, attack3 = "attack3", attack4 = "attack4", attack5 = "attack5"
		, defense2 = "defend2", defense3 = "defend3", defense4 = "defend4"}
var texture = preload("res://Assets/Art/better icon dummy.png")

func _ready():
	for x in (actions.keys()):
		get_node("ItemList").add_item(actions[x],texture,true)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
