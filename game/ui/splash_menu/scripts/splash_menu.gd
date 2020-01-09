extends CenterContainer

# Button focus
export (NodePath) var starting_button
var _current_focus  = null

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _ready():
	_initialize()

################################################################################
# PRIVATE METHODS
################################################################################

func _initialize():
	get_node(starting_button).grab_focus()

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_NewGame_pressed():
	get_tree().call_group('game_master', 'load_new_game')

#-------------------------------------------------------------------------------

func _on_Quit_pressed():
	get_tree().quit()

#-------------------------------------------------------------------------------

func _on_Tutorial_pressed():
	get_tree().call_group('game_master', 'load_tutorial')
