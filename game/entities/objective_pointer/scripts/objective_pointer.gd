extends Sprite

# Signals 
signal move_completed

# Child nodes
onready var _audio = $AudioStreamPlayer2D
onready var _move_tween = $MoveTween

# Movement
export (float) var move_speed = 0.0 # pixels/second

################################################################################
# PRIVATE METHODS
################################################################################

func _play_sound():
	_audio.play()

################################################################################
# PUBLIC METHODS
################################################################################

func move_to_location(location):
	var distance = position.distance_to(location)
	var time = distance / move_speed
	
	_move_tween.interpolate_property(
		self,
		'position',
		position,
		location,
		time, 
		Tween.TRANS_SINE,
		Tween.EASE_IN)
	
	_move_tween.start()
	_play_sound()

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_MoveTween_tween_completed(object, key):
	emit_signal('move_completed')
