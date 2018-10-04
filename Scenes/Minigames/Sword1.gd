extends "res://Scenes/Minigames/Minigame.gd"

#The scale where circle_inner matches circle_target
const threshold_outer = .39

#The scale where circle_inner matches circle_target2
const threshold_inner = .265


const MAX_SPEED = 5
const DEFAULT_SPEED = 2
var minigame_speed = DEFAULT_SPEED
onready var temppoly = $Polygon2D.polygon
onready var temppoly2 = $Polygon2D.polygon

onready var temppolyhead = $Polygon2D2.polygon
onready var temppolyhead2 = $Polygon2D2.polygon

func _ready():
	$Timer.start()
	
	for x in temppoly.size():
		temppoly.set(x, Vector2($Polygon2D.polygon[x].x, $Polygon2D.polygon[x].y))
	$Polygon2D.polygon = temppoly
	
	for x in temppolyhead.size():
		temppolyhead.set(x, Vector2($Polygon2D2.polygon[x].x, $Polygon2D2.polygon[x].y))
	$Polygon2D2.polygon = temppolyhead


func _process(delta):
	
	if $Timer.time_left > 0:
		for x in temppoly.size():
			temppoly.set(x, Vector2(temppoly2[x].x * (1-(1.0*$Timer.time_left/$Timer.wait_time)), temppoly2[x].y))
		$Polygon2D.polygon = temppoly
		for x in temppolyhead.size():
			temppolyhead.set(x, Vector2(temppolyhead2[x].x * (1-(1.0*$Timer.time_left/$Timer.wait_time)), temppolyhead2[x].y))
		$Polygon2D2.polygon = temppolyhead
	
	var scaleAmount = minigame_speed * 0.3 * delta
	$ViewportContainer/Viewport/Node2D/Circle_Inner.scale -= Vector2(scaleAmount, scaleAmount)
	$ViewportContainer/Viewport/Node2D.rotate(deg2rad(15*delta*minigame_speed))
	$ViewportContainer/Viewport/Node2D.rotate(deg2rad(2*-15*delta*minigame_speed))
	
	if $ViewportContainer/Viewport/Node2D/Circle_Inner.scale.x < threshold_outer and $ViewportContainer/Viewport/Node2D/Circle_Inner.scale.y > threshold_inner:
		set("modulate", Color(1,1,.1))
		
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("hit")
			
			#resetting this mini game
			$ViewportContainer/Viewport/Node2D/Circle_Inner.scale = Vector2(1, 1)
			set("modulate", Color(1,1,1))
			
			if minigame_speed < MAX_SPEED:
				minigame_speed += .2
				pass
	
	if Input.is_action_just_pressed("ui_accept") and $ViewportContainer/Viewport/Node2D/Circle_Inner.scale.x < .95:
		_finish_minigame()
	
	if $ViewportContainer/Viewport/Node2D/Circle_Inner.scale.x <= 0:
		_finish_minigame()

#calling parent method (inherited)
func _finish_minigame():
	._finish_minigame()