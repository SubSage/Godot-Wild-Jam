extends Node2D

signal action_chosen(action)

var options = {
	"Normal Attack": "normalattack",
	"Special Attack": "specialattack",
	"Defend": "defend"
}

func _ready():
	_update_options()

func _update_options():
	$ItemList.clear()
	
	for key in options:
		$ItemList.add_item(key, null, true)
		pass

func replace_options(new_options):
	options = new_options
	_update_options()

func _on_ItemList_item_activated(index):
	emit_signal("action_chosen", options[$ItemList.get_item_text(index)])
