extends Node


var options = null


#Magic numbers are bad, but there's no documentation on how to get a theme's font that I can find
const fontHeight = 16


onready var spacingHeight = $ItemList.theme.get_constant("Vseparation", "int")


func _process(delta):
	var newHeight = 0.0
	newHeight += (fontHeight + spacingHeight) * $ItemList.get_item_count() / 2
	
	$ItemList.set_anchor(MARGIN_BOTTOM, newHeight)