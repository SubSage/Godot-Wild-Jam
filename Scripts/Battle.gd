extends Node2D

var turn = 0

var Robot = preload("res://Scenes/Robot.tscn")
var Enemy = preload("res://Scenes/Enemy.tscn")

var enemies = []
var robots = []

var selectedRobot
var selectedEnemy

var enemyIndex = 0
#-1:player turn;  0+: enemy index taking turn
var enemyturnindex = -1

var focusswitchtime = .2


#UI elements
onready var actionList = $UI/ActionList
onready var enemyStats = $UI/enemyStats
onready var playerStats = $UI/playerStats

var isEnemyTurn = false
var nextMonsterCanAttack = true
var attackingEnemy = 0

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


func _process(delta):
	if Input.is_action_just_pressed("ui_quit"): #switch to game menu eventually or something
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
	
	if (Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")) and actionList.is_paused():
		if Input.is_action_just_pressed("ui_left"):
			change_target("left")
		elif Input.is_action_just_pressed("ui_right"):
			change_target("right")

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

func robot_busy(duration, dmg):
	#Not sure if this is unused, I'll remove this later
	print("robot_busy called!!!")
	if dmg==0:
		$Timer.wait_time=duration
		$Timer.start()
		actionList.pause(true)
		return
	
	selectedEnemy.attacked(dmg)
	
	if selectedEnemy.currentHealth <= 0:
		enemies[enemyIndex].set("modulate", Color(.2,.2,.2))
		enemies.remove(enemyIndex)
		if(enemies.size() == 0):
			get_tree().change_scene("res://Scenes/MainMenu.tscn")
		else:
			enemyIndex -= 1
			if enemyIndex <= 0:
				enemyIndex = enemies.size() - 1
			
			selectedEnemy=enemies[enemyIndex]
			
			enemies[enemyIndex].set("modulate", Color(1,1,1))
			
			robots[0].stopcombo()
			return
	else:
		$Timer.wait_time=duration
		$Timer.start()
		actionList.pause(true)

func getActionList(actions):
	actionList.replace_options(actions)

func _on_ActionList_action_chosen(action):
	selectedRobot.use_attack(action)
	actionList.pause(true)
	selectedEnemy.hideReticle = true
	turn+=1
	
func robotturnover():
	actionList.pause(true)
	isEnemyTurn = true
	enemyturnindex=0
	enemyturnphase()
	
func enemyturnphase():
	if enemyturnindex >= enemies.size():
		enemyturnindex=-1
		actionList.pause(false)
		isEnemyTurn=false
		selectedEnemy.hideReticle = false
		return
	enemies[enemyturnindex].take_turn(0, robots)
	enemyturnindex += 1

func enemyattacking():
	playerStats.update_health(selectedRobot.currentHealth, selectedRobot.healthMaximum)
	playerStats.update_battery(selectedRobot.currentCharge, selectedRobot.chargeMaximum)
	pass

func _on_robot_usedNormalAttack(dmg):
	selectedEnemy.take_damage(dmg)
	updateUI()

func updateUI():
	enemyStats.update_health(selectedEnemy.currentHealth, selectedEnemy.healthMaximum)
	enemyStats.update_name(selectedEnemy.monsterName)
	update()

func enemyturnFinished():
	print("enemy finished making a move :D ")
	enemyturnphase()
	