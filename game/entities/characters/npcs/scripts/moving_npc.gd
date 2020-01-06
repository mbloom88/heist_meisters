extends "res://entities/characters/npcs/scripts/stationary_npc.gd"

# Child nodes
onready var _wait_timer= $WaitTimer
onready var _new_path_delay = $NewPathDelay

# Movement
onready var _nav = get_tree().get_nodes_in_group('navigation').pop_front()
export (float) var walk_speed = 0.0
export (int) var min_arrival_distance = 0
var _destinations = []
var _path = []

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _physics_process(delta):
	if is_on_wall() and _new_path_delay.is_stopped():
		_new_path_delay.start()
	
	if _path:
		_navigate()

#-------------------------------------------------------------------------------

func _ready():
	_initialize_destinations()

################################################################################
# PRIVATE METHODS
################################################################################

func _initialize_destinations():
	"""
	Updates the available destinations that the NPC can navigate to within the
	level.
	"""
	randomize()
	
	if _nav:
		_destinations = _nav.provide_destinations()
		_make_new_path()

#-------------------------------------------------------------------------------

func _make_new_path():
	"""
	Creates a new path between two locations for the NPC to navigate through.
	"""
	var new_destination = _destinations[randi() % _destinations.size() - 1]
	_path = []
	_motion = Vector2()
	
	if new_destination == position:
		_make_new_path()
	else:
		_path = Array(_nav.get_simple_path(position, new_destination, false))

#-------------------------------------------------------------------------------

func _navigate():
	"""
	Allows the NPC to navigate through a path of destinations.
	"""
	var distance = position.distance_to(_path[0])
	
	if distance > min_arrival_distance:
		var direction = (_path[0] - position).normalized()
		look_at(_path[0])
		_motion = direction * walk_speed
		move_and_slide(_motion)
	else:
		if _path.size() > 1:
			_path.pop_front()
		elif _path.size() == 1 and _wait_timer.is_stopped():
			_wait_timer.start()
			_path.pop_front()

################################################################################
# PUBLIC METHODS
################################################################################

func start_physics_processing():
	set_physics_process(true)

#-------------------------------------------------------------------------------

func stop_physics_processing():
	set_physics_process(false)
	

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_WaitTimer_timeout():
	"""
	Timer that starts after the NPC has reached a final destination after 
	navigating the level. Once the timer has timed out, a new navigation path
	is created. 
	"""
	_make_new_path()

#-------------------------------------------------------------------------------

func _on_NewPathDelay_timeout():
	"""
	Timer that starts after the NPC has encountered an obstacle during
	navigation. Once the timer has timed out, this method checks to see if the
	NPC is still obstructed. If so, a new navigation path is created. 
	"""
	if is_on_wall():
		_make_new_path()
