extends Sprite

var health = 100

var actions = {
	"Normal Attack": "attack_normal",
	"Special Attack": "attack_special",
	"Defend": "defend",
	"Wait": "wait"
}

var movedata= [{hits=1, length=5, timing=2, precision = .2}]

signal on_click(robot, actions)
signal busy(duration)
func _ready():
	get_node("Area2D/CollisionShape2D").shape.set("extents", Vector2(get_texture().get_width()/2,get_texture().get_height()/2))

func _process(delta):
	if get_node("Timer").is_stopped() == false and (abs(movedata[0].length - get_node("Timer").time_left - movedata[0].timing) <=   movedata[0].precision):
		set("modulate", Color(.8,.2,.2))
	else:
		set("modulate", Color(1,1,1))
	update()


func on_click():
	emit_signal("on_click", self, actions)
	if get_node("Timer").is_stopped() == false and (abs(movedata[0].length - get_node("Timer").time_left - movedata[0].timing) <=   movedata[0].precision):
#		print("you did it!"+ str(get_node("Timer").time_left) )
		get_node("Particles2D").restart()


func actionmove(var index):
	if index == "attack_normal":
		emit_signal("busy", 5)
		pass
	get_node("Timer").wait_time=movedata[0].length
	get_node("Timer").start()
	get_node("Tween").interpolate_property(self, "position",
			Vector2(0,0), position, movedata[0].length,
			Tween.TRANS_BACK,Tween.EASE_OUT)
	get_node("Tween").start()


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		on_click()
