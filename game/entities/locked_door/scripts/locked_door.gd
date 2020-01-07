extends "res://entities/door/scripts/door.gd"

# Child nodes
onready var _numpad = $CanvasLayer/Numpad

################################################################################
# USER-DEFINED VIRTUAL METHODS (FROM BUILT-INS)
################################################################################

func _on_input(event):
	if Input.is_action_just_pressed('interact') and _has_player_interacting: 
		if not _numpad.is_unlocked:
			_numpad.popup_centered()
		else:
			_open()

################################################################################
# PUBLIC METHODS
################################################################################

func set_new_passcode(new_passcode):
	"""
	Args:
		- code (String): Code must be a string of numbers (e.g. 1234).
	"""
	_numpad.set_new_passcode(new_passcode)

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_Door_body_exited(body):
	._on_Door_body_exited(body) # calls parent script
	
	if body.collision_layer in _player_collision:
		_numpad.hide()

#-------------------------------------------------------------------------------

func _on_Numpad_unlocked():
	_open()
