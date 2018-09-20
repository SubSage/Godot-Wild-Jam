extends Node

var options = {
	"test": "test",
	"test2": "test2",
	"test3": "b luh",
	"test4": "hi",
	"test5": "god"
}

func _ready():
	_load_available_options()

func _load_available_options():
	$ActionList.replace_options(options)

func _on_ActionList_action_chosen(action):
	#Put code to handle that here
pass