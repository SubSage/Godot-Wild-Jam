extends Sprite

var hp = 5
var gsprite = preload("res://Assets/Art/better icon dummy.png")
var bullhead = preload("res://Assets/Art/bull_feast/bull head.png")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	if(randf() < .35):
		$head.set_texture(bullhead)
		$head.scale=Vector2(.6,.6)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func attacked(x):
	hp -= x
#	print(hp)
	if hp <= 0:
		self.set_texture(gsprite)
		set("modulate", Color(.3,.3,.3))
#		queue_free()
	else:
		$Tween.interpolate_property(self, "modulate", Color(.3,.3,.3), Color(1,1,1), 1,Tween.TRANS_BACK,Tween.EASE_IN)
		$Tween.start()
		
