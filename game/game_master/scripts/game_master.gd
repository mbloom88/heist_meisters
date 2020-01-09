extends Node

# Child nodes
onready var _BGM
onready var _level_handler = $LevelHandler
onready var _menu_handler = $MenuHandler
onready var _front_screen = $FrontScreen

# Levels 
var _new_level = ""

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _ready():
	load_menu('splash')

################################################################################
# PUBLIC METHODS
################################################################################

func load_new_game():
	_menu_handler.remove_current_menu()
	_level_handler.start_new_game()

#-------------------------------------------------------------------------------

func load_tutorial():
	_menu_handler.remove_current_menu()
	_level_handler.start_tutorial()

#-------------------------------------------------------------------------------

func load_menu(new_menu):
	_menu_handler.add_new_menu(new_menu)

#-------------------------------------------------------------------------------

func restart_current_level():
	_front_screen.remove_screen()
	_level_handler.restart_current_level()

#-------------------------------------------------------------------------------

func show_game_over():
	_front_screen.display_screen('game_over')
	_level_handler.remove_current_level()

#-------------------------------------------------------------------------------

func show_victory(new_level):
	_new_level = new_level
	_front_screen.display_screen('victory')
	_level_handler.remove_current_level()

#-------------------------------------------------------------------------------

func start_next_mission():
	if _new_level:
		_front_screen.remove_screen()
		_level_handler.add_new_level(_new_level)
		_new_level = ""
