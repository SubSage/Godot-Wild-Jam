extends Sprite

var health = 100
var actions = {
	"Sword Attack": "attack_normal",
	"Special Attack": "attack_special",
	"Defend": "defend",
	"Wait": "wait"
}

var movedata=[
	{name= "attack_normal",hits=1, length=2, timing=2, precision = .2},
	{name= "special_normal",hits=1, length=2, timing=2, precision = .2}]

onready var timer = $Timer
signal on_click(robot, actions)
signal busy(duration, dmg)

func _ready():
#	set("visible", false)
	get_node("Area2D/CollisionShape2D").shape.set("extents", Vector2(get_texture().get_width()/2,get_texture().get_height()/2))
#	$AnimationPlayer.play("idle")
	
func _process(delta):
	if (not timer.is_stopped()) and (abs(movedata[0].length - timer.time_left - movedata[0].timing) <=   movedata[0].precision):
		set("modulate", Color(.8,.2,.2))
	else:
		set("modulate", Color(1,1,1))
	update()

func on_click():
	emit_signal("on_click", self, actions)
	if (not timer.is_stopped()) and (abs(movedata[0].length - timer.time_left - movedata[0].timing) <=   movedata[0].precision):
#		print("you did it!"+ str(timer.time_left) )
		get_node("Particles2D").restart()
		actionmove("attack_normal")
		


func actionmove(var index, var combo = 0):
	if index == "attack_normal":
		timer.wait_time=movedata[0].length
		timer.start()
		get_node("Tween").interpolate_property(self, "position",
				Vector2(0,0), position, movedata[0].length,
				Tween.TRANS_BACK,Tween.EASE_OUT)
		get_node("Tween").start()
		emit_signal("busy", movedata[0].length, 1)

func stopcombo():
	timer.stop()
	$Tween.reset_all()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		on_click()
