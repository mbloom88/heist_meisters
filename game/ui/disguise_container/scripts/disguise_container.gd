extends NinePatchRect

# Child nodes
onready var _disguise_display = $VBoxContainer/DisguiseDisplay

# Disguises
export (Resource) var disguise_box_texture

################################################################################
# PUBLIC METHODS
################################################################################

func update_disguise_count(number):
	_disguise_display.clear()
	
	for i in range(number):
		_disguise_display.add_icon_item(disguise_box_texture, false)
