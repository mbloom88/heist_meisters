extends CanvasModulate

# Child nodes
onready var _audio = $AudioStreamPlayer
onready var _toggle_delay = $ToggleDelay

# Visions
export (Array) var visions = [
	Color.midnightblue,	# default dark
	Color.lime]			# nightvision
export (Resource) var nightvision_on
export (Resource) var nightvision_off
var _index = 0

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _ready():
	set_default_vision()

################################################################################
# PUBLIC METHODS
################################################################################

func cycle_through_visions():
	"""
	Toggles through visions.
	"""
	if _toggle_delay.is_stopped():
		_index += 1
		
		if _index == visions.size():
			_index = 0
			_audio.stream = nightvision_off
		else:
			_audio.stream = nightvision_on
		
		color = visions[_index]
		get_tree().call_group('npcs', 'toggle_flashlight')
		_audio.play()
		_toggle_delay.start()

#-------------------------------------------------------------------------------

func set_default_vision():
	color = visions[0]
