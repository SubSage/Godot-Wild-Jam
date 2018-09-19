extends ItemList


onready var height_font = self.theme.get_font("font", "").get_height()

onready var half_height_font = height_font / 2

onready var height_spacing = self.theme.get_constant("vseparation", "ItemList")


func _process(delta):
	#This is a little bit complicated.
	#Initially, set it to height_font + height_spacing, then multiply by the number of items.
	#However, this doesn't account for the top of the first item/the bottom of the last item, so add height_font twice more
	var newHeight = ((height_font + height_spacing) * self.get_item_count()) + height_font * 2
	
	newHeight += self.margin_top
	
	margin_bottom = newHeight