extends Node


var options = null


onready var fontHeight = $ItemList.theme.get_font("font", "").get_height()


onready var spacingHeight = $ItemList.theme.get_constant("Vseparation", "int")


func _process(delta):
	var newHeight = 0.0
	newHeight += (fontHeight + spacingHeight) * $ItemList.get_item_count() / 2
	
	$ItemList.set_anchor(MARGIN_BOTTOM, newHeight)