extends Node

# Child nodes
onready var _BGM
onready var _level_handler = $LevelHandler
onready var _front_screen = $FrontScreen

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _ready():
	_level_handler.start_new_game()

################################################################################
# PUBLIC METHODS
################################################################################

func restart_current_level():
	_front_screen.remove_screen()
	_level_handler.restart_current_level()

#-------------------------------------------------------------------------------

func show_game_over():
	_front_screen.display_screen('game_over')
	_level_handler.remove_current_level()

#-------------------------------------------------------------------------------

func show_victory():
	_front_screen.display_screen('victory')
	_level_handler.remove_current_level()
