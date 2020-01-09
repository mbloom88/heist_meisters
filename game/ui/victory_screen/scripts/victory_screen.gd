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

func _on_NextMission_pressed():
	pass # Replace with function body.

#-------------------------------------------------------------------------------

func _on_Quit_pressed():
	get_tree().quit()

#-------------------------------------------------------------------------------

func _on_TryAgain_pressed():
	get_tree().call_group('game_master', 'restart_current_level')
