extends Node2D

var turn = 0
var enemies = []
var robots = []
var Robot = preload("res://Scenes/Robot.tscn")
var Enemy = preload("res://Scenes/Enemy.tscn")
var selectedRobot
var selectedEnemy
var enemy=1
var rect = Rect2(0,0,10,10)
var focusswitchtime = .2
onready var actionlist = $ActionList

func _ready():
	$AudioStreamPlayer.play()
	var r = Robot.instance()
	r.connect("on_click", self, "getActionList")
	r.connect("busy", self, "robot_busy")
	r.position = Vector2(300,500)
	selectedRobot=r
	add_child(r)
	move_child(r,0)
	robots.append(r)
	
	var e = Enemy.instance()
	e.position = Vector2(1200,300)
	e.scale=Vector2(.6,.6)
	add_child(e)
	move_child(e,0)
	
	var ee = Enemy.instance()
	ee.position = Vector2(1600,600)
	add_child(ee)
	getActionList(r, r.actions)
	enemies.append(e)
	enemies.append(ee)
	selectedEnemy= enemies[enemy]
	
func _process(delta):
	if Input.is_action_just_pressed("ui_quit"):
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
		
	if Input.is_action_just_pressed("ui_left") and actionlist.is_paused():
		enemy-=1
		if enemy<=-1:
			enemy=enemies.size()-1
		$Tween.interpolate_property(selectedEnemy, "position",
			selectedEnemy.position, Vector2(selectedEnemy.position.x + 100, selectedEnemy.position.y),
			focusswitchtime, Tween.TRANS_BACK,Tween.EASE_OUT)
		$Tween.start()
		
		selectedEnemy.set("modulate", Color(.2,.6,.6))
		selectedEnemy=enemies[enemy]
		$Tween.interpolate_property(selectedEnemy, "position",
			selectedEnemy.position, Vector2(selectedEnemy.position.x - 100, selectedEnemy.position.y),
			focusswitchtime, Tween.TRANS_BACK,Tween.EASE_OUT)
		$Tween.start()
		
		robot_busy(focusswitchtime, 0)
		update()


func _draw():
#	var rect = Rect2(selectedEnemy.position,
#			Vector2(selectedEnemy.get_texture().get_width(), selectedEnemy.get_texture().get_height()))
#	draw_rect(rect, Color(.5,.3,.5),true)
	enemies[enemy].set("modulate", Color(1,1,1))
	pass


func robot_busy(duration, dmg):
	$Timer.wait_time=duration
	$Timer.start()
	actionlist.pause(true)
	selectedEnemy.attacked(dmg)
	if selectedEnemy.hp <= 0:
		enemies.remove(enemy)
		print("enemy size: " + str(enemies.size()))
		if(enemies.size() == 0):
			get_tree().change_scene("res://Scenes/MainMenu.tscn")
		else:
			enemy-=1
			if enemy<=0:
				enemy=enemies.size()-1
			selectedEnemy=enemies[enemy]
	
	update()

func getActionList(robot, actions):
	selectedRobot=robot
	actionlist.position = Vector2(robot.position.x, robot.position.y + robot.get_texture().get_height()/2-200)
	actionlist.replace_options(actions)


func _on_ActionList_action_chosen(action):
	selectedRobot.actionmove(action)
	turn+=1


func _on_Timer_timeout():
	actionlist.pause(false)
	pass
