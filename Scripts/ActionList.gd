extends Node2D

signal action_chosen(action)

#These are a bunch of default options.
#TODO: Replace the values with "null" so that the program
#will always crash if it isn't initialized by the user
var options = null

func _ready():
	_update_options()

func _process(delta):
	if options == null:
		self.hide()
	else:
		self.show()

func _update_options():
	if options == null:
		return
	
	$ItemList.clear()
	
	for key in options:
		$ItemList.add_item(key, null, true)
		pass

func replace_options(new_options):
	options = new_options
	_update_options()

func _on_ItemList_item_activated(index):
	emit_signal("action_chosen", options[$ItemList.get_item_text(index)])
