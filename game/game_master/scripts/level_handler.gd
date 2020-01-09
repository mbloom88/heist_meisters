extends Node

# Levels
export (PackedScene) var level_001
var _current_level = ""

################################################################################
# PUBLIC METHODS
################################################################################

func add_new_level(new_level):
	"""
	Args:
		- new_level (String): The level name.
	"""
	if get_children():
		remove_current_level()
	
	var level = null
	_current_level = new_level
	
	match new_level:
		'level_001':
			level = level_001.instance()
	
	add_child(level)

#-------------------------------------------------------------------------------

func remove_current_level():
	var current_level = get_child(0)
	remove_child(current_level)
	current_level.queue_free()

#-------------------------------------------------------------------------------

func restart_current_level():
	add_new_level(_current_level)

#-------------------------------------------------------------------------------

func start_new_game():
	add_new_level('level_001')
