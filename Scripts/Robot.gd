extends Sprite
var health = 100
var actions = {attack1 = "attack1", attack2 = "attack2", defense = "defend", def2 = "def2"}
var movedata= [{hits=1, length=5, timing=2, precision = .2}]
signal on_click
var attack=false

func _ready():
	for a in rand_range(0,10):
		actions[a] = ""+str(randi()%100)
	self.connect("on_click", get_parent(), "getActionList")

func _process(delta):
	if get_node("Timer").is_stopped() == false and (abs(movedata[0].length - get_node("Timer").time_left - movedata[0].timing) <=   movedata[0].precision):
		set("modulate", Color(.8,.2,.2))
	else:
		set("modulate", Color(1,1,1))
	update()
	pass
	
func on_click():
	emit_signal("on_click",[self, actions])
	if get_node("Timer").is_stopped() == false and (abs(movedata[0].length - get_node("Timer").time_left - movedata[0].timing) <=   movedata[0].precision):
		print("you did it!"+ str(get_node("Timer").time_left) )
		get_node("Particles2D").restart()


func actionmove(var index):
#	print(actions[index])
	get_node("Timer").wait_time=movedata[0].length
	get_node("Timer").start()
	get_node("Tween").interpolate_property(self, "position",
			Vector2(0,0), position, movedata[0].length,
			Tween.TRANS_BACK,Tween.EASE_OUT)
	get_node("Tween").start()
	print("timer starting")
	pass