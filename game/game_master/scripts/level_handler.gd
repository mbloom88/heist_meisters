extends Node

# Levels
export (PackedScene) var level_001

################################################################################
# PUBLIC METHODS
################################################################################

func add_new_level(new_level):
	"""
	Args:
		- new_level (String): The level name.
	"""
	if get_children():
		var old_level = get_child(0)
		remove_child(old_level)
		old_level.queue_free()
	
	var next_level = ""
	
	match new_level:
		'level_001':
			next_level = level_001.instance()
	
	add_child(next_level)

#-------------------------------------------------------------------------------

func start_new_game():
	add_new_level('level_001')
