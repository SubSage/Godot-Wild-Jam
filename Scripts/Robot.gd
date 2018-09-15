extends Sprite
var health = 100
var actions = {attack1 = "attack1", attack2 = "attack2", defense = "defend", def2 = "def2"}
signal on_click


func _ready():
	for a in rand_range(0,10):
		actions[a] = ""+str(randi()%100)
	self.connect("on_click", get_parent(), "getActionList")
	pass
	
func on_click():
	emit_signal("on_click",[actions])