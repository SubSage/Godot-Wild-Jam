extends Node2D

signal action_chosen(action)

var options = null

#Magic numbers are bad, but there's no documentation on how to get a theme's font that I can find
const fontHeight = 16

onready var spacingHeight = $ItemList.theme.get_constant("Vseparation", "int")

func _ready():
	replace_options(null)

func _process(delta):
	if options == null:
		self.hide()
		return
	else:
		self.show()
	
	#I would rather not put this in the _process function, but if I put it in
	#_update_options, it needs to be double-clicked for it to work.
	var newHeight = 0.0
	newHeight += (fontHeight + spacingHeight) * options.size()
	
	$ItemList.set_anchor(MARGIN_BOTTOM, newHeight)


func _update_options():
	$ItemList.clear()
	
	if options == null:
		return
	
	for key in options:
		$ItemList.add_item(key, null, true)
		
	$ItemList.grab_focus()
	$ItemList.select(0)

func replace_options(new_options):
	options = new_options
	_update_options()


func _on_ItemList_item_activated(index):
	if $ItemList.is_item_selectable(index):
		emit_signal("action_chosen", options[$ItemList.get_item_text(index)])

func pause(pause):
	for item in $ItemList.get_item_count():
		$ItemList.set_item_disabled(item, pause)
		$ItemList.set_item_selectable(item, not pause)

func _on_ItemList_item_selected(index):
	$clicksound.play()
	pass # replace with function body
