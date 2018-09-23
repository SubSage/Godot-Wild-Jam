extends Node2D

var turn = 0


var Robot = preload("res://Scenes/Robot.tscn")
var Enemy = preload("res://Scenes/Enemy.tscn")

var enemies = []
var robots = []

var selectedRobot
var selectedEnemy

var enemyIndex = 0


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
	add_child(r)
	move_child(r,0)
	robots.append(r)
	
	getActionList(r.actions)
	
	
	var e = Enemy.instance()
	e.position = $Points/Kaiju4.position
	add_child(e)
	e.scale=Vector2(.7, .7)
	move_child(e,0)
	
	
	var ee = Enemy.instance()
	ee.position = $Points/Kaiju3.position
	ee.scale=Vector2(.8, .8)
	add_child(ee)
	
	
	var eee = Enemy.instance()
	eee.position = $Points/Kaiju2.position
	eee.scale = Vector2(.9, .9)
	add_child(eee)
	
	
	var eeee = Enemy.instance()
	eeee.position = $Points/Kaiju1.position
	add_child(eeee)
	
	
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
	
	
	$Tween.interpolate_property(selectedEnemy, "position",
		selectedEnemy.position, Vector2(selectedEnemy.position.x - 300, selectedEnemy.position.y),
		focusswitchtime, Tween.TRANS_BACK,Tween.EASE_OUT)
	$Tween.start()


func _process(delta):
	if Input.is_action_just_pressed("ui_quit"):
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
		
	enemyStats.update_health(selectedEnemy.currentHealth, selectedEnemy.healthMaximum)
	enemyStats.update_name(selectedEnemy.monsterName)
	
	playerStats.update_health(selectedRobot.currentHealth, selectedRobot.healthMaximum)
	playerStats.update_battery(selectedRobot.currentCharge, selectedRobot.chargeMaximum)
	
	if isEnemyTurn:
		selectedEnemy.hideReticle = true
		actionList.pause(true)
		processEnemyTurn(delta, robots)
	else:
		selectedEnemy.hideReticle = false
		processPlayerTurn(delta)


func processPlayerTurn(delta):
	if !selectedRobot.is_attacking:
		player_idle(delta)


func player_idle(delta):
	if (Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")) and actionList.is_paused():
		if Input.is_action_just_pressed("ui_left"):
			enemyIndex -= 1
		
		if Input.is_action_just_pressed("ui_right"):
			enemyIndex += 1
		
		if enemyIndex <= -1:
			enemyIndex = enemies.size()-1
		
		elif enemyIndex >= enemies.size():
			enemyIndex = 0
			
		#The previously-selected enemy
		selectedEnemy.isSelected = false
		
		$Tween.interpolate_property(selectedEnemy, "position",
			selectedEnemy.position, Vector2(selectedEnemy.position.x + 300, selectedEnemy.position.y),
			focusswitchtime, Tween.TRANS_BACK,Tween.EASE_OUT)
		$Tween.start()
		
		selectedEnemy.set("modulate", Color(.2,.6,.6))
		
		#The now-selected enemy
		selectedEnemy=enemies[enemyIndex]
		selectedEnemy.isSelected = true
		selectedEnemy.set("modulate", Color(1,1,1))
		
		$Tween.interpolate_property(selectedEnemy, "position",
			selectedEnemy.position, Vector2(selectedEnemy.position.x - 300, selectedEnemy.position.y),
			focusswitchtime, Tween.TRANS_BACK,Tween.EASE_OUT)
		$Tween.start()


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


func processEnemyTurn(delta, robots):
	if nextMonsterCanAttack == false:
		return
	
	if !enemies[attackingEnemy].hasAttacked:
		enemies[attackingEnemy].take_turn(delta, robots)
	
	attackingEnemy += 1
	
	if attackingEnemy >= enemies.size():
		isEnemyTurn = false
		
		for enemy in enemies:
			enemy.hasAttacked = false
		
		attackingEnemy = 0
		nextMonsterCanAttack = true
		
		actionList.pause(false)
		$MonsterTimer.stop()
	else:
		nextMonsterCanAttack = false
		$MonsterTimer.start()


func _on_MonsterTimer_timeout():
	if isEnemyTurn:
		nextMonsterCanAttack = true


func getActionList(actions):
	actionList.replace_options(actions)


func _on_ActionList_action_chosen(action):
	selectedRobot.use_attack(action)
	turn+=1
	
	if turn % 2 == 0:
		actionList.pause(false)
		isEnemyTurn = false
	else:
		actionList.pause(true)
		isEnemyTurn = true


func _on_robot_usedNormalAttack(dmg):
	selectedEnemy.take_damage(dmg)