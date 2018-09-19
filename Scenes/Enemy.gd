extends Sprite

var hp = 5

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func attacked(x):
	hp -= x
	print(hp)
	if hp <= 0:
		set("modulate", Color(.3,.3,.3))
#		queue_free()
		pass
		