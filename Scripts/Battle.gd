extends Node2D

var turn = 0

var Robot = preload("res://Scenes/Robot.tscn")
var Enemy = preload("res://Scenes/Enemy.tscn")

var enemies = []
var robots = []

var selectedRobot
var selectedEnemy

#for selection. Should rename
var enemyIndex = 0

#-1:player turn;  0+: enemy index taking turn
var enemyturnindex = -1

#length of transition when selecting different enemyu
var focusswitchtime = .2


#UI elements
onready var actionList = $UI/ActionList
onready var enemyStats = $UI/enemyStats
onready var playerStats = $UI/playerStats

var isEnemyTurn = false

func _ready():
	var r = Robot.instance()
	r.position = $Points/PlayerSpawn.position
	selectedRobot=r
	r.connect("usedNormalAttack", self, "_on_robot_usedNormalAttack")
	r.connect("robotturnover", self, "robotturnover")
	add_child(r)
	move_child(r,0)
	robots.append(r)
	
	getActionList(r.actions)
	
	var e = Enemy.instance()
	e.position = $Points/Kaiju4.position
	add_child(e)
	e.scale=Vector2(.7, .7)
	move_child(e,0)
	e.connect("finishedTurn", self, "enemyturnFinished")
	e.connect("enemyattacking", self, "enemyattacking")
	
	var ee = Enemy.instance()
	ee.position = $Points/Kaiju3.position
	ee.scale=Vector2(.8, .8)
	add_child(ee)
	ee.connect("finishedTurn", self, "enemyturnFinished")
	ee.connect("enemyattacking", self, "enemyattacking")
	
	var eee = Enemy.instance()
	eee.position = $Points/Kaiju2.position
	eee.scale = Vector2(.9, .9)
	add_child(eee)
	eee.connect("finishedTurn", self, "enemyturnFinished")
	eee.connect("enemyattacking", self, "enemyattacking")
	
	var eeee = Enemy.instance()
	eeee.position = $Points/Kaiju1.position
	add_child(eeee)
	eeee.connect("finishedTurn", self, "enemyturnFinished")
	eeee.connect("enemyattacking", self, "enemyattacking")
	
	enemies.append(e)
	enemies.append(ee)
	enemies.append(eee)
	enemies.append(eeee)
	
	
	e.z_index=-20
	ee.z_index=-20
	eee.z_index=-20
	eeee.z_index=-20
	
	
	selectedEnemy = enemies[enemyIndex]
	selectedEnemy.isSelected = true
	selectedEnemy.set("modulate", Color(1,1,1))
	updateUI()
	
	$Tween.interpolate_property(selectedEnemy, "position",
		selectedEnemy.position, Vector2(selectedEnemy.position.x - 300, selectedEnemy.position.y),
		focusswitchtime, Tween.TRANS_BACK,Tween.EASE_OUT)
	$Tween.start()
	
	$Tween.interpolate_property($Environment, "modulate",
		Color(1,1,1,1), Color(1,1,1,0),
		5, Tween.TRANS_SINE,Tween.EASE_IN)
	$Tween.start()

func _process(delta):
	if Input.is_action_just_pressed("ui_quit"): #switch to game menu eventually or something
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
	
	if (Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")) and actionList.is_paused():
		if Input.is_action_just_pressed("ui_left"):
			change_target("left")
		elif Input.is_action_just_pressed("ui_right"):
			change_target("right")

#update which enemy is selected
func change_target(switch_direction = "default"):
	#The previously-selected enemy
	$Tween.interpolate_property(selectedEnemy, "position",
		selectedEnemy.position, Vector2(selectedEnemy.position.x + 300, selectedEnemy.position.y),
		focusswitchtime, Tween.TRANS_BACK,Tween.EASE_OUT)
	$Tween.start()
	selectedEnemy.set("modulate", Color(.2,.2,.2))
	selectedEnemy.isSelected = false
	selectedEnemy.hideReticle = true
	
	match switch_direction:
		"default":
			enemyIndex = 0
		"left":
			enemyIndex-=1
		"right":
			enemyIndex+=1
	if enemyIndex <= -1:
		enemyIndex = enemies.size()-1
	elif enemyIndex >= enemies.size():
		enemyIndex = 0
		
	#The now-selected enemy
	selectedEnemy=enemies[enemyIndex]
	selectedEnemy.isSelected = true
	selectedEnemy.hideReticle = false
	selectedEnemy.set("modulate", Color(1,1,1))
	$Tween.interpolate_property(selectedEnemy, "position",
		selectedEnemy.position, Vector2(selectedEnemy.position.x - 300, selectedEnemy.position.y),
		focusswitchtime, Tween.TRANS_BACK,Tween.EASE_OUT)
	$Tween.start()
	updateUI()
	pass

func getActionList(actions):
	actionList.replace_options(actions)

func _on_ActionList_action_chosen(action):
	selectedEnemy.hideReticle = true
	actionList.pause(true)
	selectedRobot.use_attack(action)

#robot's turn is over, starting enemy phase
func robotturnover():
	actionList.pause(true)
	isEnemyTurn = true
	enemyturnindex=0
	enemyturnphase()

#enemy finished making it's move, move to next one, if none left, move to playerturn
func enemyturnphase():
	if enemyturnindex >= enemies.size():
		enemyturnindex=-1
		actionList.pause(false)
		isEnemyTurn=false
		selectedEnemy.hideReticle = false
		turn+=1
		return
	enemies[enemyturnindex].take_turn(0, robots)
	enemyturnindex += 1

#enemy has hit, update player UI
func enemyattacking():
	playerStats.update_health(selectedRobot.currentHealth, selectedRobot.healthMaximum)
	playerStats.update_battery(selectedRobot.currentCharge, selectedRobot.chargeMaximum)
	pass

func _on_robot_usedNormalAttack(dmg):
	selectedEnemy.take_damage(dmg)
	if selectedEnemy.currentHealth <= 0:
		selectedEnemy.killed()
		enemies.remove(enemyIndex)
		if(enemies.size() == 0):
			get_tree().change_scene("res://Scenes/MainMenu.tscn")
		else:
			enemyIndex-=1
			if enemyIndex == -1:
				enemyIndex = enemies.size()-1
			selectedEnemy = enemies[enemyIndex]
			selectedEnemy.set("modulate", Color(1,1,1))
			robots[0].stopcombo()
			updateUI()
	updateUI()

func updateUI():
	enemyStats.update_health(selectedEnemy.currentHealth, selectedEnemy.healthMaximum)
	enemyStats.update_name(selectedEnemy.monsterName)
	update()

func enemyturnFinished():
	enemyturnphase()
	