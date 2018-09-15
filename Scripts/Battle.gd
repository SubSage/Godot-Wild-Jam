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
	r.connect("on_click", self, "getActionList")
	r.position = Vector2(300,600)
	add_child(r)
	
	var e = Enemy.instance()
	e.position = Vector2(1400,600)
	add_child(e)
	
	var rr = Robot.instance()
	rr.position = Vector2(500,400)
	rr.actions["test"] = "testattack"
	rr.actions["Nothing Important"] = "anothertestattack"
	add_child(rr)
	
	var ee = Enemy.instance()
	ee.position = Vector2(1600,400)
	rr.connect("on_click", self, "getActionList")
	add_child(ee)


func getActionList(robot, actions):
	get_node("ActionList").replace_options(actions)
	selectedRobot=robot
	print(selectedRobot)


func _on_ActionList_action_chosen(action):
	print("item activated #" + action)
	selectedRobot.actionmove(action)
