extends "res://entities/characters/scripts/character.gd"

# Signals
signal vision_toggled

# Child nodes
onready var _sprite = $Sprite

# Player
export (Resource) var player_sprite

# Disguises
export (Resource) var disguise_box_sprite
var _is_disguised = false

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _input(event):
	if Input.is_action_just_pressed('toggle_vision'):
		emit_signal('vision_toggled')
	elif Input.is_action_just_pressed('toggle_disguise'):
		_toggle_disguise()

#-------------------------------------------------------------------------------

func _physics_process(delta):
	_update_movement()
	move_and_slide(_motion)

################################################################################
# PRIVATE METHODS
################################################################################

func _toggle_disguise():
	if _is_disguised:
		_sprite.texture = player_sprite
	else:
		_sprite.texture = disguise_box_sprite

#-------------------------------------------------------------------------------

func _update_movement():
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed('move_up'):
		_motion.y = clamp(_motion.y - acceleration, -max_speed, 0)
	elif Input.is_action_pressed('move_down'):
		_motion.y = clamp(_motion.y + acceleration, 0, max_speed)
	else:
		_motion.y = lerp(_motion.y, 0, friction)
	
	if Input.is_action_pressed('move_left'):
		_motion.x = clamp(_motion.x - acceleration, -max_speed, 0)
	elif Input.is_action_pressed('move_right'):
		_motion.x = clamp(_motion.x + acceleration, 0, max_speed)
	else:
		_motion.x = lerp(_motion.x, 0, friction)
