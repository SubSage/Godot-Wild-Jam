extends Sprite


var monsterName = "GODRA BABY"


#If it's not evolving, kaiju generates an int between 1 and 100.
#If it's lower than this number, it begins evolving.
#Decrease this number with each passing evolution.
var evolutionChance = 30

var healthMaximum = 350
var currentHealth = healthMaximum

var attackStrength = 5

var isEvolving = false
var timesEvolved = 0
var turnsTillEvolution = 2

var gsprite = preload("res://Assets/Art/power_core.png")
var bullhead = preload("res://Assets/Art/bull_feast/bull head.png")

#Sound arrays
var ambientSounds = [
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

var isSelected = false
var hideReticle = false


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
#		get_node("BodyParts/head").scale=Vector2(.6,.6)
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
#		get_node("BodyParts/head").scale=Vector2(.6,.6)
	pass


func _process(delta):
	if isSelected && !hideReticle:
		$Reticle.show()
	else:
		$Reticle.hide()
	
	if isEvolving:
		$BodyParts.hide()
		$Cocoon.show()
	else:
		$BodyParts.show()
		$Cocoon.hide()


func attacked(x):
	currentHealth -= x
#	print(currentHealth)
	if currentHealth <= 0:
		self.set_texture(gsprite)
		$BodyParts.visible=false
		set("modulate", Color(.3,.3,.3))
#		queue_free()
	else:
		$Tween.interpolate_property(self, "modulate", Color(.3,.3,.3), Color(1,1,1), 1,Tween.TRANS_BACK,Tween.EASE_IN)
		$Tween.start()
		


func takeTurn(delta, robots):
	$Timer.start()
	if monsterName == "GODRA OMEGA":
#		print("Monster attacks!")
		attack(delta, robots)
		
	elif isEvolving:
#		print("Monster is busy evolving!")
		turnsTillEvolution -= 1
		$Tween.interpolate_property(self, "modulate", Color(.2,.2,.2), Color(1,1,1), 1,Tween.TRANS_BACK,Tween.EASE_IN)
		$Tween.start()
		
		if turnsTillEvolution == 0:
			finish_evolving()
			isEvolving = false
	else:
		var whichAction = (randi() % 100) + 1
		
		if whichAction <= evolutionChance:
#			print("Monster has entered a coccoon!")
			isEvolving = true
		else:
#			print("Monster attacks!")
			attack(delta, robots)


func attack(delta, robots):
	#Select which robot to hit
	$Tween.interpolate_property(self, "modulate", Color(.9,.2,.2), Color(1,1,1), 1,Tween.TRANS_BACK,Tween.EASE_IN)
	$Tween.start()
	var robotTarget = 0
	
	if robots.size() != 1:
		robotTarget = rand_range(0, robots.size()-1)
	
	var selectedRobot = robots[robotTarget]
	
	#Timed hits stuff goes here
	selectedRobot.currentHealth -= int(attackStrength + rand_range(-2, 2))
	
	play_sound(ambientSounds)


func finish_evolving():
#	print("Monster emerges in a more powerful form!")
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
		
		pass
	healthMaximum += 100
	currentHealth = healthMaximum
	play_sound(cocoonBreakingSounds)
	isEvolving=false
	timesEvolved += 1
	turnsTillEvolution = 2


func play_sound(soundArray):
	var soundNumber = rand_range(0, soundArray.size())
	$AmbientSound.stream = soundArray[soundNumber]
	$AmbientSound.play(0)

func _on_Timer_timeout():
	hasAttacked = true
	pass # replace with function body
