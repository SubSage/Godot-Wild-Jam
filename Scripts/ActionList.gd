extends Node2D

signal action_chosen(action)

var options = null

func _ready():
	_update_options()

func _update_options():
	if options == null:
		return
	
	$ItemList.clear()
	
	for key in options:
		$ItemList.add_item(key, null, true)
	
	

func replace_options(new_options):
	if options == null:
		self.hide()
	else:
		self.show()
	
	options = new_options
	_update_options()

func _on_ItemList_item_activated(index):
	emit_signal("action_chosen", options[$ItemList.get_item_text(index)])
