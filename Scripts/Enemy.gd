extends Sprite


var monsterName = "Godra"

#If it's not evolving, kaiju generates an int between 1 and 100.
#If it's lower than this number, it begins evolving.
#Decrease this number with each passing evolution.
var evolutionChance = 20

var currentHealth = 5
var healthMaximum = 5

var isEvolving = false
var timesEvolved = 0
var turnsTillEvolution = 2

var gsprite = preload("res://Assets/Art/power_core.png")
var bullhead = preload("res://Assets/Art/bull_feast/bull head.png")

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
		


func takeTurn():
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
			attack()


func attack():
	pass


func finish_evolving():
	print("Monster emerges in a more powerful form!")
	currentHealth = healthMaximum