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

# Loot
var loot_total = 0 setget , get_loot_total

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
		_update_disguise_timer_label()

#-------------------------------------------------------------------------------

func _ready():
	_initialize()

################################################################################
# PRIVATE METHODS
################################################################################

func _disguise_player():
	get_tree().call_group('disguise_timer_label', 'show')
	_disguise_timer.start()
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

func _update_disguise_timer_label():
	"""
	Updates the GUI element 'DisguiseTimerLabel' with the Player and the
	current DisguiseTimer int value.
	"""
	get_tree().call_group('disguise_timer_label', 'update_label', self,
		_disguise_timer.time_left)

#-------------------------------------------------------------------------------

func _reveal_player():
	get_tree().call_group('disguise_timer_label', 'hide')
	_disguise_timer.stop()
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

func collect_loot(loot_texture):
	"""
	Updates the GUI element 'LootTracker' with the texture of the 'Loot' that 
	was collected.
	"""
	loot_total += 1
	get_tree().call_group('loot_tracker', 'update_loot_display', loot_texture)

#-------------------------------------------------------------------------------

func update_disguise_count():
	"""
	Updates the GUI element 'DisguiseDisplay' with the current number of 
	disguise charges remaining.
	"""
	get_tree().call_group('disguise_display', 'update_disguise_count', 
		disguise_charges)

################################################################################
# GETTERS
################################################################################

func get_loot_total():
	return loot_total

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_DisguiseTimer_timeout():
	if _is_disguised:
		_reveal_player()
