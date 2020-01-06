extends Area2D

# Child nodes
onready var _anim = $AnimationPlayer
onready var _screen = $CanvasLayer/ComputerScreen

# Computer
export (String, MULTILINE) var screen_text = ""

# Locked door
export (String) var passcode # Must be numbers!
export (NodePath) var locked_door_scene
var _locked_door = null

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _input(event):
	if Input.is_action_just_pressed('interact'): 
		_screen.popup_centered()

#-------------------------------------------------------------------------------

func _ready():
	set_process_input(false)
	
	assert locked_door_scene
	_locked_door = get_node(locked_door_scene)
	
	_blink()
	_set_screen_text()

################################################################################
# PRIVATE METHODS
################################################################################

func _blink():
	_anim.play('blink')

#-------------------------------------------------------------------------------

func _set_screen_text():
	_screen.set_screen_text(screen_text)

################################################################################
# PUBLIC METHODS
################################################################################

func assign_new_passcode():
	_locked_door.set_new_passcode(passcode)

#-------------------------------------------------------------------------------

func _on_Computer_body_entered(body):
	if body.collision_layer == 1:
		set_process_input(true)

#-------------------------------------------------------------------------------

func _on_Computer_body_exited(body):
	if body.collision_layer == 1:
		set_process_input(false)
		_screen.hide()
