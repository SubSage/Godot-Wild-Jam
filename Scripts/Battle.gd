extends Node2D

var turn = 0
var enemies = []
var robots = []
var Robot = preload("res://Scenes/Robot.tscn")
var Enemy = preload("res://Scenes/Enemy.tscn")
var selectedRobot
var selectedEnemy
var enemy=0
var rect = Rect2(0,0,10,10)
var focusswitchtime = .2
onready var actionlist = $ActionList


var isEnemyTurn = false
var nextMonsterCanAttack = true
var attackingEnemy = 0


func _ready():
	var r = Robot.instance()
	r.connect("on_click", self, "getActionList")
	r.connect("busy", self, "robot_busy")
	r.position = Vector2(300,500)
	selectedRobot=r
	add_child(r)
	move_child(r,0)
	robots.append(r)
	
	var e = Enemy.instance()
	e.position = Vector2(1000,350-15)
	add_child(e)
	e.scale=Vector2(.55,.55)
	move_child(e,0)
	
	var ee = Enemy.instance()
	ee.position = Vector2(1200,500-15)
	ee.scale=Vector2(.7,.7)
	add_child(ee)
	
	var eee = Enemy.instance()
	eee.position = Vector2(1400,650-15)
	eee.scale=Vector2(.85,.85)
	add_child(eee)
	
	var eeee = Enemy.instance()
	eeee.position = Vector2(1600,800-15)
	add_child(eeee)
	getActionList(r, r.actions)
	enemies.append(e)
	enemies.append(ee)
	enemies.append(eee)
	enemies.append(eeee)
	e.z_index=-2
	ee.z_index=-2
	eee.z_index=-2
	eeee.z_index=-2
	
	selectedEnemy = enemies[enemy]
	selectedEnemy.isSelected = true
	selectedEnemy.set("modulate", Color(1,1,1))


func _process(delta):
	if Input.is_action_just_pressed("ui_quit"):
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
		
	$enemyStats.update_health(selectedEnemy.currentHealth, selectedEnemy.healthMaximum)
	$enemyStats.update_name(selectedEnemy.monsterName)
	
	$playerStats.update_health(selectedRobot.currentHealth, selectedRobot.healthMaximum)
	$playerStats.update_battery(selectedRobot.currentCharge, selectedRobot.chargeMaximum)
	
	if isEnemyTurn:
		selectedEnemy.hideReticle = true
		$ActionList.pause(true)
		processEnemyTurn(delta, robots)
	else:
		selectedEnemy.hideReticle = false
		processPlayerTurn(delta)
		
		for enemy in enemies:
			enemy.hasAttacked = false


func processPlayerTurn(delta):
	if (Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")) and actionlist.is_paused():
		var difference = 1
		if Input.is_action_just_pressed("ui_left"):
			difference = -1
		enemy+=difference
		if enemy<=-1:
			enemy=enemies.size()-1
		elif enemy >= enemies.size():
			enemy=0
			
		#The previously-selected enemy
		selectedEnemy.isSelected = false
		
		$Tween.interpolate_property(selectedEnemy, "position",
			selectedEnemy.position, Vector2(selectedEnemy.position.x + 300, selectedEnemy.position.y),
			focusswitchtime, Tween.TRANS_BACK,Tween.EASE_OUT)
		$Tween.start()
		
		selectedEnemy.set("modulate", Color(.2,.6,.6))
		
		#The now-selected enemy
		selectedEnemy=enemies[enemy]
		selectedEnemy.isSelected = true
		enemies[enemy].set("modulate", Color(1,1,1))
		
		$Tween.interpolate_property(selectedEnemy, "position",
			selectedEnemy.position, Vector2(selectedEnemy.position.x - 300, selectedEnemy.position.y),
			focusswitchtime, Tween.TRANS_BACK,Tween.EASE_OUT)
		$Tween.start()
		
		robot_busy(focusswitchtime, 0)
	update()


func processEnemyTurn(delta, robots):
	if nextMonsterCanAttack == false:
		return
	
	if !enemies[attackingEnemy].hasAttacked:
		enemies[attackingEnemy].takeTurn(delta, robots)
	
	attackingEnemy += 1
	
	if attackingEnemy >= enemies.size():
		isEnemyTurn = false
		attackingEnemy = 0
		nextMonsterCanAttack = true
		$ActionList.pause(false)
		$MonsterTimer.stop()
	else:
		nextMonsterCanAttack = false
		$MonsterTimer.start()


func _on_MonsterTimer_timeout():
	nextMonsterCanAttack = true

func _draw():
#	var rect = Rect2(selectedEnemy.position,
#			Vector2(selectedEnemy.get_texture().get_width(), selectedEnemy.get_texture().get_height()))
#	draw_rect(rect, Color(.5,.3,.5),true)
	pass


func robot_busy(duration, dmg):
	if dmg==0:
		$Timer.wait_time=duration
		$Timer.start()
		actionlist.pause(true)
		return
	
	selectedEnemy.attacked(dmg)
	
	if selectedEnemy.currentHealth <= 0:
		enemies[enemy].set("modulate", Color(.2,.2,.2))
		enemies.remove(enemy)
#		print("enemy size: " + str(enemies.size()))
		if(enemies.size() == 0):
			get_tree().change_scene("res://Scenes/MainMenu.tscn")
		else:
			enemy-=1
			if enemy<=0:
				enemy=enemies.size()-1
			selectedEnemy=enemies[enemy]
			enemies[enemy].set("modulate", Color(1,1,1))
			robots[0].stopcombo()
			return
	else:
		$Timer.wait_time=duration
		$Timer.start()
		actionlist.pause(true)
	update()


func getActionList(robot, actions):
	selectedRobot=robot
	actionlist.replace_options(actions)


func _on_ActionList_action_chosen(action):
	selectedRobot.actionmove(action)
	turn+=1


func _on_Timer_timeout():
	robots[0].stopcombo()
	if turn % 2 == 0:
		actionlist.pause(false)
		isEnemyTurn = false
	else:
		actionlist.pause(true)
		isEnemyTurn = true
		
	print("turn " + str(turn) + " over!")
	print(isEnemyTurn)
	pass

