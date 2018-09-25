extends "res://Scenes/Minigames/Minigame.gd"

#The scale where circle_inner matches circle_target
const threshold_outer = .39

#The scale where circle_inner matches circle_target2
const threshold_inner = .265


const MAX_SPEED = 7
const DEFAULT_SPEED = 2
var minigame_speed = DEFAULT_SPEED

func _process(delta):
	var scaleAmount = minigame_speed * 0.3 * delta
	
	$Circle_Inner.scale -= Vector2(scaleAmount, scaleAmount)
	
	if Input.is_key_pressed(KEY_SPACE):
		if $Circle_Inner.scale.x < threshold_outer and $Circle_Inner.scale.y > threshold_inner:
			emit_signal("hit")
			
			#resetting this mini game
			$Circle_Inner.scale = Vector2(1, 1)
			
			if minigame_speed < MAX_SPEED:
				minigame_speed += 1
	
	if $Circle_Inner.scale.x <= 0:
		_finish_minigame()


func _finish_minigame():
	._finish_minigame()