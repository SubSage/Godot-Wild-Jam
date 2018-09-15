extends Node2D
var xx = 123
func _ready():
	position = Vector2(3,3)
	pass

func test_func():
	print("child")
	print(xx)