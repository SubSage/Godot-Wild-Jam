extends Sprite


var monsterName = "Godra"

#If it's not evolving, kaiju generates an int between 1 and 100.
#If it's lower than this number, it begins evolving.
#Decrease this number with each passing evolution.
var evolutionChance = 20

var currentHealth = 5
var healthMaximum = 5

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
	if(randf() < .35):
		get_node("BodyParts/head").set_texture(bullhead)
		get_node("BodyParts/head").scale=Vector2(.6,.6)
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
	hasAttacked = true
	
	if isEvolving:
		print("Monster is busy evolving!")
		turnsTillEvolution -= 1
		
		if turnsTillEvolution == 0:
			finish_evolving()
			isEvolving = false
	else:
		var whichAction = (randi() % 100) + 1
		
		if whichAction <= evolutionChance:
			print("Monster has entered a coccoon!")
			isEvolving = true
		else:
			print("Monster attacks!")
			attack(delta, robots)


func attack(delta, robots):
	#Select which robot to hit
	var robotTarget = 0
	
	if robots.size() != 1:
		robotTarget = rand_range(0, robots.size()-1)
	
	var selectedRobot = robots[robotTarget]
	
	#Timed hits stuff goes here
	selectedRobot.currentHealth -= int(attackStrength + rand_range(-2, 2))
	
	play_sound(ambientSounds)


func finish_evolving():
	print("Monster emerges in a more powerful form!")
	currentHealth = healthMaximum
	play_sound(cocoonBreakingSounds)


func play_sound(soundArray):
	var soundNumber = rand_range(0, soundArray.size())
	$AmbientSound.stream = soundArray[soundNumber]
	$AmbientSound.play(0)