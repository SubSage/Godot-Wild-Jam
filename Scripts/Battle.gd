extends Node2D

var turn = 0
var enemies = {}
var robots = {}
var Robot = preload("res://Scenes/Robot.tscn")
var Enemy = preload("res://Scenes/Enemy.tscn")
var selectedRobot

#change to load up proper robot(player)/ enemy data
func _ready():
	var r = Robot.instance()
	var e = Enemy.instance()
	add_child(r)
	add_child(e)
	r.position = Vector2(300,600)
	e.position = Vector2(1400,600)
	
	r.connect("on_click", self, "getActionList")
	
	var rr = Robot.instance()
	var ee = Enemy.instance()
	add_child(rr)
	add_child(ee)
	rr.position = Vector2(500,400)
	ee.position = Vector2(1600,400)
	rr.actions["test"]="teststst"
	rr.actions["tesssdfsdft"]="big boom attack"
	rr.actions["t3"]="YAS DADDY"
	rr.actions["teddddddddddddd"]="tst"
	
	rr.connect("on_click", self, "getActionList")
	pass

func getActionList(robot, actions):
	get_node("ActionList").replace_options(actions)
	selectedRobot=robot
	print(selectedRobot)


func _on_ActionList_action_chosen(action):
	print("item activated #" + action)
	selectedRobot.actionmove(action)
