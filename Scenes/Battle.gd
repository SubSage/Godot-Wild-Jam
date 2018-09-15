extends Node2D

var turn = 0
var enemies = {}
var robots = {}
var Robot = preload("res://Scenes/Robot.tscn")
var Enemy = preload("res://Scenes/Enemy.tscn")

#change to load up proper robot(player)/ enemy data
func _ready():
	
	var r = Robot.instance()
	var e = Enemy.instance()
	add_child(r)
	add_child(e)
	r.position = Vector2(300,600)
	e.position = Vector2(1400,600)
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
	pass

func getActionList(var list):
	var x = list[0].duplicate()
	get_node("ItemList").clear()
	for k in x.keys():
		get_node("ItemList").add_item(x[k],null,true)
	get_node("ItemList").visible=true
	pass


func _on_ItemList_nothing_selected():
	print("nothing selected")
	pass # replace with function body


func _on_ItemList_item_selected(index):
	print("item selected #" + str(index))
	pass # replace with function body


func _on_ItemList_item_activated(index):
	print("item activated #" + str(index))
	pass # replace with function body
