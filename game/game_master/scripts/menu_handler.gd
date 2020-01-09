extends CanvasLayer

# Menus
export (PackedScene) var splash
var _current_menu = ""

################################################################################
# PUBLIC METHODS
################################################################################

func add_new_menu(new_menu):
	var menu = null
	_current_menu = new_menu
	
	match new_menu:
		'splash':
			menu = splash.instance()
	
	add_child(menu)

#-------------------------------------------------------------------------------

func remove_current_menu():
	var current_menu = get_children().pop_back()
	remove_child(current_menu)
	current_menu.queue_free()
