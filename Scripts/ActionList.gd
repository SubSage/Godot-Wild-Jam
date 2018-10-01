extends Control


signal action_chosen(action)


export (int) var columns = 1


var options = null


func _ready():
	$ItemList.max_columns = columns
	
	replace_options(null)


func _process(delta):
	if options == null:
		self.hide()
		return
	else:
		self.show()


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
	
	if pause:
		$ItemList.release_focus()
		$ItemList.hide()
	else:
		$ItemList.grab_focus()
		$ItemList.show()


func is_paused():
	return $ItemList.has_focus()


func _on_ItemList_item_selected(index):
	if $ItemList.is_item_selectable(index):
		$clicksound.play()
	pass # replace with function body
