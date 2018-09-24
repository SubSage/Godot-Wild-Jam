extends Sprite


#Whether or not an attack is being used. Used to pause updating in Battle.gd until the minigame is over.
var is_attacking = false


#Simple signals to emit every time the enemy should be damaged
signal usedNormalAttack(dmg)
signal usedSpeciaclAttack(dmg)


#Current health, and maximum
var healthMaximum = 600
var currentHealth = healthMaximum


#Current charge, and maximum
var chargeMaximum = 5
var currentCharge = chargeMaximum


#How many times the player has successfully comboed. Minigames can use this to terminate if a combo limit is reached
var combo = 0


#Chooseable actions
var actions = {
	"Sword Attack": "attack_normal",
	"Special Attack": "attack_special",
	"Defend": "defend",
	"Wait": "wait"
}


#DEPRECIATED. Data will be moved to the minigames
var movedata=[
	{name= "attack_normal",hits=1, length=2.0, timing=2, precision = .2},
	{name= "special_normal",hits=1, length=2.0, timing=2, precision = .2}
]


#The weapon the player currently has. Used for minigame/damage calculations, changed in the Upgrade menu.
var currentWeapon_Normal = {
	"name": "Basic Sword",
	"description": "Just a basic sword. Nothing special about it.",
	"minigame": "Sword1",
	"damage": 5,
	"random": 2
}


#Instance of the weapons' minigame.
var attackMinigame_Normal


onready var timer = $Timer


#Leftover of when multiple playable robots were planned.
#signal on_click(robot, actions)


func _ready():
	attackMinigame_Normal = load_minigame()
	
	attackMinigame_Normal.connect("hit", self, "_on_attackMinigame_Normal_hit")
	attackMinigame_Normal.connect("finished", self, "_on_attackMinigame_Normal_finish")
	
	attackMinigame_Normal.position = Vector2(800, -680)
	
	add_child(attackMinigame_Normal)
	attackMinigame_Normal.hide()
#	$AnimationPlayer.play("idle")


func load_minigame():
	return load("res://Scenes/Minigames/" + currentWeapon_Normal["minigame"] + ".tscn").instance()


func use_attack(var index):
	match index:
		"attack_normal":
			is_attacking = true
			
			#Always give the player one hit, then start the minigame so they can earn more
			_on_attackMinigame_Normal_hit()
			attackMinigame_Normal.start()
			attackMinigame_Normal.show()
		
		"attack_special":
			print("Special attacks aren't yet implimented")
		
		"defend":
			print("Defending not yet implimented")
		
		"wait":
			print("Waiting isn't finished yet")


func _on_attackMinigame_Normal_hit():
	combo += 1
	
	var damageDealt = currentWeapon_Normal["damage"] + int(rand_range(-currentWeapon_Normal["random"], currentWeapon_Normal["random"]))
	
	emit_signal("usedNormalAttack", damageDealt)


func _on_attackMinigame_Normal_finish():
	attackMinigame_Normal.hide()
	combo = 0
	is_attacking = false