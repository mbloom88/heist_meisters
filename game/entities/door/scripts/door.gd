extends Area2D

# Child nodes
onready var _anim = $AnimationPlayer
onready var _audio = $AudioStreamPlayer2D
onready var _stuck_timer = $StuckNPCTimer

# Door options
var _has_player_interacting = false
var _previous_anim = 'close'
var _interacting_npcs = []

# Collision
export (Array) var _player_collision
export (Array) var _npc_collision

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _input(event):
	"""
	WARNING: When inheriting from this class and attempting to override Godot
	built-in virtual methods, Godot does not allow the inheriting class to
	override built-ins. Godot first runs the parent built-in virtual method
	and then runs the inheriting built-in virtual method.
	
	In standard OOP design, inheriting classes have the ability to override 
	parent methods. To avoid calling the parent built-in virtual method in 
	Godot, a user-defined virtual method can be written, as shown below.
	
	https://github.com/godotengine/godot/issues/6500
	"""
	_on_input(event)

#-------------------------------------------------------------------------------

func _process(delta):
	_check_for_stuck_npcs()

################################################################################
# USER-DEFINED VIRTUAL METHODS (FROM BUILT-INS)
################################################################################

func _on_input(event):
	if Input.is_action_just_pressed('interact') and _has_player_interacting:
		_open()

################################################################################
# PRIVATE METHODS
################################################################################

func _check_for_stuck_npcs():
	if _interacting_npcs:
		_open()
	
	if _stuck_timer.is_stopped():
		_stuck_timer.start()

#-------------------------------------------------------------------------------

func _close():
	if not _anim.is_playing() and _previous_anim == 'open':
		_anim.play('close')

#-------------------------------------------------------------------------------

func _open():
	if not _anim.is_playing() and _previous_anim == 'close':
		_anim.play('open')

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_AnimationPlayer_animation_finished(anim_name):
	_previous_anim = anim_name
	
	if _interacting_npcs:
		_interacting_npcs[0].start_physics_processing()

#-------------------------------------------------------------------------------

func _on_Door_body_entered(body):
	if body.collision_layer in _player_collision:
		_has_player_interacting = true
	elif body.collision_layer in _npc_collision:
		if not _interacting_npcs:
			set_process(true)
			_interacting_npcs.append(body)
			_interacting_npcs[0].stop_physics_processing()
			_open()
		else:
			_interacting_npcs.append(body)

#-------------------------------------------------------------------------------

func _on_Door_body_exited(body):
	if body.collision_layer in _player_collision:
		_has_player_interacting = false
	elif body.collision_layer in _npc_collision and body in _interacting_npcs:
		_interacting_npcs.erase(body)
	
	if _interacting_npcs.empty() and not _has_player_interacting:
		set_process(false)
		_close()

#-------------------------------------------------------------------------------

func _on_StuckNPCTimer_timeout():
	if _interacting_npcs:
		for npc in _interacting_npcs:
			npc.start_physics_processing()
