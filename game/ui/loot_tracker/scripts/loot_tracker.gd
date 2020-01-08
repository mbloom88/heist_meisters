extends NinePatchRect

# Child nodes
onready var _loot_display = $VBoxContainer/LootDisplay

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _ready():
	_loot_display.clear()

################################################################################
# PUBLIC METHODS
################################################################################

func update_loot_display(loot_texture):
	_loot_display.add_icon_item(loot_texture, false)
