extends Sprite

var healthMaximum = 600
var currentHealth = healthMaximum

var chargeMaximum = 5
var currentCharge = chargeMaximum
var combo = 0


var actions = {
	"Sword Attack": "attack_normal",
	"Special Attack": "attack_special"
#	"Defend": "defend",
#	"Wait": "wait"
}

var movedata=[
	{name= "attack_normal",hits=1, length=2.0, timing=2, precision = .2},
	{name= "special_normal",hits=1, length=2.0, timing=2, precision = .2}
]


onready var timer = $Timer
signal on_click(robot, actions)
signal busy(duration, dmg)


func _ready():
	$Sprite.visible=false
	get_node("Sprite/Area2D/CollisionShape2D").shape.set("extents", Vector2(get_node("Sprite").get_texture().get_width()/2, get_node("Sprite").get_texture().get_height()/2))
#	$AnimationPlayer.play("idle")
	
	
func _process(delta):
	$Sprite.rotate(.5*delta*combo)
	if (not timer.is_stopped()) and (abs(movedata[0].length - timer.time_left - movedata[0].timing) <=   movedata[0].precision):
		set("modulate", Color(.2,.2,.8))
	else:
		set("modulate", Color(1,1,1))
	update()


func on_click():
	if (not timer.is_stopped()) and (abs(movedata[0].length - timer.time_left - movedata[0].timing) <=   movedata[0].precision) and combo < 4:
		$Particles2D.set_texture(load("res://GUI/label_Perfect.png"))
		get_node("Particles2D").restart()
		actionmove("attack_normal")
	else:
		$Particles2D.set_texture(load("res://GUI/label_Miss.png"))
		$Particles2D.restart()
		stopcombo()


func actionmove(var index):
	if index == "attack_normal":
		combo+=1
		$Sprite.visible=true
		timer.wait_time=movedata[0].length
		timer.start()
		get_node("Tween").interpolate_property(get_node("Sprite/Sprite"), "scale",
				Vector2(1,1), Vector2(.25,.25), movedata[0].length,
				Tween.TRANS_QUAD,Tween.EASE_OUT)
		get_node("Tween").start()
		emit_signal("busy", movedata[0].length, 25)


func stopcombo():
	timer.stop()
	$Tween.stop_all()
	$Sprite.visible=false
	combo = 0


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		on_click()
