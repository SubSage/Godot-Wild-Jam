extends Sprite


var monsterName = "GODRA BABY"
signal finishedTurn
signal enemyattacking

#If it's not evolving, kaiju generates an int between 1 and 100.
#If it's lower than this number, it begins evolving.
#Decrease this number with each passing evolution.
var evolutionChance = 30

var healthMaximum = 50
var currentHealth = healthMaximum

var attackStrength = 5

var isEvolving = false
var timesEvolved = 0
var turnsTillEvolution = 2

var gsprite = preload("res://Assets/Art/power_core.png")
var bullhead = preload("res://Assets/Art/bull_feast/bull head.png")
var minigame = preload("res://Scenes/Minigames/Sword1.tscn")
var selectedRobot

#Sound arrays
var attackingSounds = [
	preload("res://Assets/Audio/kaiju/Growl_0.wav"),
	preload("res://Assets/Audio/kaiju/Growl_1.wav"),
	preload("res://Assets/Audio/kaiju/Growl_2.wav"),
	preload("res://Assets/Audio/kaiju/Growl_3.wav"),
	preload("res://Assets/Audio/kaiju/Growl_4.wav"),
	preload("res://Assets/Audio/kaiju/GrowlBig_0.wav"),
	preload("res://Assets/Audio/kaiju/GrowlBig_1.wav"),
	preload("res://Assets/Audio/kaiju/GrowlLow_0.wav"),
	preload("res://Assets/Audio/kaiju/GrowlLow_1.wav")
]


var cocoonBreakingSounds = [
	preload("res://Assets/Audio/kaiju/CocoonExplode_0.wav")
]


var hurtSounds = [

]


var hasAttacked = false


func _ready():
	var type = randf()
	if(type < .30):
		monsterName = "INSECTRO"
		get_node("BodyParts/tale").set_texture(load("res://Assets/Art/Nova pasta/insect_tale.png"))
		get_node("BodyParts/foot left").set_texture(load("res://Assets/Art/Nova pasta/insect_left foot.png"))
		get_node("BodyParts/biceps left").set_texture(load("res://Assets/Art/Nova pasta/insect_left biceps.png"))
		get_node("BodyParts/body").set_texture(load("res://Assets/Art/Nova pasta/insect_body.png"))
		get_node("BodyParts/biceps right").set_texture(load("res://Assets/Art/Nova pasta/insect_right biceps.png"))
		get_node("BodyParts/hand left").set_texture(load("res://Assets/Art/Nova pasta/insect_left hand.png"))
		get_node("BodyParts/hand right").set_texture(load("res://Assets/Art/Nova pasta/insect_right hand.png"))
		get_node("BodyParts/head").set_texture(load("res://Assets/Art/Nova pasta/insect_head.png"))
		get_node("BodyParts/foot right").set_texture(load("res://Assets/Art/Nova pasta/insect_right foot.png"))
	elif (type < .6):
		monsterName = "BIG BULL FROM SPACE"
		get_node("BodyParts/tale").set_texture(load("res://Assets/Art/Nova pasta/bull_tale.png"))
		get_node("BodyParts/foot left").set_texture(load("res://Assets/Art/Nova pasta/bull_left foot.png"))
		get_node("BodyParts/biceps left").set_texture(load("res://Assets/Art/Nova pasta/bull_left biceps.png"))
		get_node("BodyParts/body").set_texture(load("res://Assets/Art/Nova pasta/bull_body.png"))
		get_node("BodyParts/biceps right").set_texture(load("res://Assets/Art/Nova pasta/bull_right biceps.png"))
		get_node("BodyParts/hand left").set_texture(load("res://Assets/Art/Nova pasta/bull_left hand.png"))
		get_node("BodyParts/hand right").set_texture(load("res://Assets/Art/Nova pasta/bull_right hand.png"))
		get_node("BodyParts/head").set_texture(load("res://Assets/Art/Nova pasta/bull_head.png"))
		get_node("BodyParts/foot right").set_texture(load("res://Assets/Art/Nova pasta/bull_right foot.png"))

func take_damage(dmg):
	
	currentHealth -= dmg
	
	if currentHealth <= 0:
		self.set_texture(gsprite)
		$BodyParts.hide()
		set("modulate", Color(.3,.3,.3))
		
	else:
		$Tween.interpolate_property(self, "modulate", Color(.3,.3,.3), Color(1,1,1), 1,Tween.TRANS_BACK,Tween.EASE_IN)
		$Tween.start()


func take_turn(delta, robots):
	z_index=-1
	selectedRobot = robots[0]
	
	if monsterName == "GODRA OMEGA":
		attack(delta, robots)
		
	elif isEvolving:
		turnsTillEvolution -= 1
		
		$Tween.interpolate_property(self, "modulate", Color(.2,.2,.2), Color(1,1,1), 1,Tween.TRANS_BACK,Tween.EASE_IN)
		$Tween.start()
		$Timer.start()
		
		if turnsTillEvolution == 0:
			finish_evolving()
			isEvolving = false
			$BodyParts.show()
			$Cocoon.hide()
		hasAttacked = true
	else:
		var whichAction = (randi() % 100) + 1
		
		if whichAction <= evolutionChance:
			isEvolving = true
			hasAttacked = true
			$Timer.start()
			$BodyParts.hide()
			$Cocoon.show()
		else:
			attack(delta, robots)


func attack(delta, robots):
	
	#Modulate enemy red briefly
	$Tween.interpolate_property(self, "modulate", Color(.9,.2,.2), Color(1,1,1), 1,Tween.TRANS_BACK,Tween.EASE_IN)
	$Tween.start()
	
	#instanciate minigame for player to go against
	var mini = minigame.instance()
	mini.connect("hit", self, "_on_attackMinigame_Normal_hit")
	mini.connect("finished", self, "_on_attackMinigame_Normal_finish")
	add_child(mini)
	
func _on_attackMinigame_Normal_hit():
	selectedRobot.currentHealth -= int(attackStrength + rand_range(-2, 2))
	emit_signal("enemyattacking")
	play_sound(attackingSounds)


func finish_evolving():
	if (monsterName == "GODRA BABY"
	or monsterName == "BIG BULL FROM SPACE" 
	or monsterName == "INSECTRO"):
		monsterName = "GODRA TEEN"
		get_node("BodyParts/tale").set_texture(load("res://Assets/Art/Nova pasta/teen_godra_tale.png"))
		get_node("BodyParts/tale").offset = Vector2(0,35)
		get_node("BodyParts/foot left").set_texture(load("res://Assets/Art/Nova pasta/teen_godra_left foot.png"))
		get_node("BodyParts/biceps left").set_texture(load("res://Assets/Art/Nova pasta/teen_godra_left biceps.png"))
		get_node("BodyParts/biceps left").offset = Vector2(0,-30)
		get_node("BodyParts/body").set_texture(load("res://Assets/Art/Nova pasta/teen_godra_body.png"))
		get_node("BodyParts/biceps right").set_texture(load("res://Assets/Art/Nova pasta/teen_godra_right biceps.png"))
		get_node("BodyParts/biceps right").offset = Vector2(0,-50)
		get_node("BodyParts/hand left").set_texture(load("res://Assets/Art/Nova pasta/teen_godra_left hand.png"))
		get_node("BodyParts/hand left").offset = Vector2(-90,-30)
		get_node("BodyParts/hand right").set_texture(load("res://Assets/Art/Nova pasta/teen_godra_right hand.png"))
		get_node("BodyParts/hand right").offset = Vector2(110,-10)
		get_node("BodyParts/head").set_texture(load("res://Assets/Art/Nova pasta/teen_godra_head.png"))
		get_node("BodyParts/head").offset = Vector2(15,-15)
		get_node("BodyParts/foot right").set_texture(load("res://Assets/Art/Nova pasta/teen_godra_right foot.png"))
	elif (monsterName == "GODRA TEEN"):
		monsterName = "GODRA ADULT"
		get_node("BodyParts/tale").set_texture(load("res://Assets/Art/Nova pasta/adult godra/adult_godra_tale.png"))
		get_node("BodyParts/foot left").set_texture(load("res://Assets/Art/Nova pasta/adult godra/adult_godra_left foot.png"))
		get_node("BodyParts/biceps left").set_texture(load("res://Assets/Art/Nova pasta/adult godra/adult_godra_left biceps.png"))
		get_node("BodyParts/body").set_texture(load("res://Assets/Art/Nova pasta/adult godra/adult_godra_body.png"))
		get_node("BodyParts/biceps right").set_texture(load("res://Assets/Art/Nova pasta/adult godra/adult_godra_right biceps.png"))
		get_node("BodyParts/hand left").set_texture(load("res://Assets/Art/Nova pasta/adult godra/adult_godra_left hand.png"))
		get_node("BodyParts/hand left").offset = Vector2(-70,30)
		get_node("BodyParts/hand right").set_texture(load("res://Assets/Art/Nova pasta/adult godra/adult_godra_right hand.png"))
		get_node("BodyParts/head").set_texture(load("res://Assets/Art/Nova pasta/adult godra/adult_godra_head.png"))
		get_node("BodyParts/foot right").set_texture(load("res://Assets/Art/Nova pasta/adult godra/adult_godra_right foot.png"))
	elif (monsterName == "GODRA ADULT"):
		monsterName = "GODRA OMEGA"
		get_node("BodyParts/tale").set_texture(load("res://Assets/Art/Nova pasta/grey kaiju/classic_tale.png"))
		get_node("BodyParts/foot left").set_texture(load("res://Assets/Art/Nova pasta/grey kaiju/classic_left foot.png"))
		get_node("BodyParts/biceps left").set_texture(load("res://Assets/Art/Nova pasta/grey kaiju/classic_left biceps.png"))
		get_node("BodyParts/body").set_texture(load("res://Assets/Art/Nova pasta/grey kaiju/classic_body.png"))
		get_node("BodyParts/biceps right").set_texture(load("res://Assets/Art/Nova pasta/grey kaiju/classic_right biceps.png"))
		get_node("BodyParts/hand left").set_texture(load("res://Assets/Art/Nova pasta/grey kaiju/classic_left hand.png"))
		get_node("BodyParts/hand left").offset = Vector2(-70,30)
		get_node("BodyParts/hand right").set_texture(load("res://Assets/Art/Nova pasta/grey kaiju/classic_right hand.png"))
		get_node("BodyParts/head").set_texture(load("res://Assets/Art/Nova pasta/grey kaiju/classic_head.png"))
		get_node("BodyParts/foot right").set_texture(load("res://Assets/Art/Nova pasta/grey kaiju/classic_right foot.png"))
		
	healthMaximum += 100
	currentHealth = healthMaximum
	play_sound(cocoonBreakingSounds)
	isEvolving = false
	timesEvolved += 1
	turnsTillEvolution = 2
	hasAttacked = true

func displayReticle(hideReticle):
	if !hideReticle:
		$Reticle.show()
	else:
		$Reticle.hide()

func play_sound(soundArray):
	var soundNumber = rand_range(0, soundArray.size())
	$AmbientSound.stream = soundArray[soundNumber]
	$AmbientSound.play(0)

func _on_Timer_timeout():
	hasAttacked = true
	emit_signal("finishedTurn")
	z_index=-2

func _on_attackMinigame_Normal_finish():
	hasAttacked = true
	emit_signal("finishedTurn")
	z_index=-2
