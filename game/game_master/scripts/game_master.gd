extends Node

# Child nodes
onready var _level_handler = $LevelHandler

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _ready():
	_level_handler.start_new_game()
