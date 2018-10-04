extends Sprite

#Whether or not an attack is being used. Used to pause updating in Battle.gd until the minigame is over.
var is_attacking = false

#Simple signals to emit every time the enemy should be damaged
signal usedNormalAttack(dmg)
signal usedSpeciaclAttack(dmg)
signal robotturnover

#Current health, and maximum
var healthMaximum = 600
var currentHealth = healthMaximum

#Current charge, and maximum
var chargeMaximum = 5
var currentCharge = chargeMaximum

#How many times the player has successfully comboed. Minigames can use this to terminate if a combo limit is reached
var combo = 0
var attackMinigame_Normal = 0
#Chooseable actions
var actions = {
	"Sword Attack": "attack_normal",
	"Special Attack": "attack_special",
	"Defend": "defend",
	"Wait": "wait"
}

#The weapon the player currently has. Used for minigame/damage calculations, changed in the Upgrade menu.
var currentWeapon_Normal = {
	"name": "Basic Sword",
	"description": "Just a basic sword. Nothing special about it.",
	"minigame": "Sword1",
	"damage": 5,
	"random": 2
}

#Instance of the weapons' minigame.

onready var timer = $Timer

func addminigame():
	attackMinigame_Normal = load_minigame()
	attackMinigame_Normal.connect("hit", self, "_on_attackMinigame_Normal_hit")
	attackMinigame_Normal.connect("finished", self, "_on_attackMinigame_Normal_finish")
	attackMinigame_Normal.position = Vector2(800, -680)
	add_child(attackMinigame_Normal)

func load_minigame():
	return load("res://Scenes/Minigames/" + currentWeapon_Normal["minigame"] + ".tscn").instance()

func use_attack(var index):
	match index:
		"attack_normal":
			is_attacking = true
			addminigame()
		
		"attack_special":
			emit_signal("robotturnover")
		
		"defend":
			emit_signal("robotturnover")
		
		"wait":
			emit_signal("robotturnover")

func stopcombo():
	attackMinigame_Normal._finish_minigame()

func _on_attackMinigame_Normal_hit():
	combo += 1
	var damageDealt = currentWeapon_Normal["damage"] + int(rand_range(-currentWeapon_Normal["random"], currentWeapon_Normal["random"]))
	emit_signal("usedNormalAttack", damageDealt)

func _on_attackMinigame_Normal_finish():
	combo = 0
	is_attacking = false
	emit_signal("robotturnover")