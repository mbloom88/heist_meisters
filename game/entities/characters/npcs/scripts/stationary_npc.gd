extends "res://entities/characters/scripts/character.gd"

# Child nodes
onready var _flashlight = $Flashlight

# NPC settings
export (bool) var is_stationary = false

# Detection
export (float) var fov_tolerance = 0.0
export (float) var detection_distance = 0.0

# Player
onready var _player = get_tree().get_nodes_in_group('player').pop_front()

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _process(delta):
	if _player_in_fov() and _player_in_los():
		_flashlight.change_color('red')
		get_tree().call_group('suspicion_meter', 'player_sighted')
	else:
		_flashlight.change_color('white')

################################################################################
# PRIVATE METHODS
################################################################################

func _player_in_fov():
	"""
	Checks to see if the Player is within the field of view (FOV).
	
	Returns:
		- is_in_fov (bool): True if the Player is within the FOV.
	"""
	# Set LOS origin to flashlight
	var fov_origin = _flashlight.global_position
	
	# Define which way is forward, or zero degrees.
	var npc_facing_direction = Vector2(1, 0).rotated(global_rotation)
	var direction_to_player = (_player.position - fov_origin).normalized()
	var angle = abs(direction_to_player.angle_to(npc_facing_direction))
	
	if angle < deg2rad(fov_tolerance):
		return true
	else:
		return false

#-------------------------------------------------------------------------------

func _player_in_los():
	"""
	Checks to see if the Player is within line of sight (LOS).
	
	Returns:
		- is_in_fov (bool): True if the Player is within LOS.
	"""
	# Set LOS origin to flashlight
	var los_origin = _flashlight.global_position

	var space = get_world_2d().direct_space_state
	var los_obstacle = space.intersect_ray(
		los_origin,
		_player.global_position,
		[self],
		collision_mask)
	
	# Error checking
	if not los_obstacle:
		return false
	
	var distance_to_player = \
		_player.global_position.distance_to(los_origin)
	var is_in_range = distance_to_player <= detection_distance
	
	if los_obstacle.collider == _player and is_in_range:
		return true
	else:
		return false

################################################################################
# PUBLIC METHODS
################################################################################

func toggle_flashlight():
	_flashlight.toggle_light()
