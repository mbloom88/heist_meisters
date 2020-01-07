extends "res://entities/characters/scripts/character.gd"

# Signals
signal vision_toggled

# Child nodes
onready var _sprite = $Sprite
onready var _occluder = $LightOccluder2D
onready var _collision_shape = $CollisionShape2D
onready var _light = $Light2D
onready var _vision_delay = $VisionDelay
onready var _disguise_timer = $DisguiseTimer
onready var _disguise_label = $DisguiseTimerLabel

# Player
export (Resource) var player_sprite
export (Resource) var player_occluder
export (Resource) var player_collision_shape

# Disguises
export (int) var disguise_charges = 0
export (float) var disguise_duration = 0.0
export (float) var disguise_speed_reduction = 0.0
export (Resource) var disguise_box_sprite
export (Resource) var disguise_box_occluder
export (Resource) var disguise_box_collision_shape
var _is_disguised = false

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _input(event):
	if Input.is_action_just_pressed('toggle_vision'):
		if _vision_delay.is_stopped():
			emit_signal('vision_toggled')
			_vision_delay.start()
	elif Input.is_action_just_pressed('toggle_disguise'):
		_toggle_disguise()

#-------------------------------------------------------------------------------

func _physics_process(delta):
	_update_movement()
	
	if _is_disguised:
		move_and_slide(_motion * disguise_speed_reduction)
	else:
		move_and_slide(_motion)

#-------------------------------------------------------------------------------

func _process(delta):
	if _is_disguised:
		_reorient_disguise_label()

#-------------------------------------------------------------------------------

func _ready():
	_initialize()

################################################################################
# PRIVATE METHODS
################################################################################

func _disguise_player():
	_disguise_timer.start()
	_disguise_label.show()
	_is_disguised = true
	disguise_charges -= 1
	update_disguise_count()
	_sprite.texture = disguise_box_sprite
	_occluder.occluder = disguise_box_occluder
	_collision_shape.shape = disguise_box_collision_shape
	_light.texture = disguise_box_sprite
	collision_layer = 8

#-------------------------------------------------------------------------------

func _initialize():
	_disguise_timer.wait_time = disguise_duration
	_reveal_player()

#-------------------------------------------------------------------------------

func _reorient_disguise_label():
	var locked_position = Vector2(position.x + 30, position.y - 65)
	_disguise_label.rect_global_position = locked_position
	_disguise_label.rect_rotation = -rotation_degrees
	_disguise_label.text = str(_disguise_timer.time_left).pad_decimals(2)

#-------------------------------------------------------------------------------

func _reveal_player():
	_disguise_timer.stop()
	_disguise_label.hide()
	_is_disguised = false
	_sprite.texture = player_sprite
	_occluder.occluder = player_occluder
	_collision_shape.shape = player_collision_shape
	_light.texture = player_sprite
	collision_layer = 1

#-------------------------------------------------------------------------------

func _toggle_disguise():
	if _is_disguised:
		_reveal_player()
	elif not _is_disguised and disguise_charges > 0:
		_disguise_player()

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

################################################################################
# PUBLIC METHODS
################################################################################

func update_disguise_count():
	get_tree().call_group('disguise_display', 'update_disguise_count', 
		disguise_charges)

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_DisguiseTimer_timeout():
	if _is_disguised:
		_reveal_player()
