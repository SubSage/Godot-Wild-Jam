extends Node

var turn = 0
var enemies = []
var robots = []
var Robot = preload("res://Scenes/Robot.tscn")
var Enemy = preload("res://Scenes/Enemy.tscn")
var selectedRobot
onready var actionlist = $ActionList

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
	e.position = Vector2(1400,600)
	add_child(e)
	move_child(e,0)
	
	var ee = Enemy.instance()
	ee.position = Vector2(1600,400)
	add_child(ee)
	getActionList(r, r.actions)
	enemies.append(e)
	enemies.append(ee)

func _process(delta):
	if Input.is_action_just_pressed("ui_quit"):
		get_tree().change_scene("res://Scenes/MainMenu.tscn")

func robot_busy(duration):
	$Timer.wait_time=duration
	$Timer.start()
	actionlist.pause(true)

func getActionList(robot, actions):
	selectedRobot=robot
	actionlist.position = Vector2(robot.position.x, robot.position.y + robot.get_texture().get_height()/2)
	actionlist.replace_options(actions)


func _on_ActionList_action_chosen(action):
	selectedRobot.actionmove(action)
	turn+=1
	print(turn)


func _on_Timer_timeout():
	actionlist.pause(false)
