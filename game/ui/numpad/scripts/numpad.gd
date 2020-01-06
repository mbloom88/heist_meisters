extends Popup
"""
WARNING: Make sure Popup node's minimum rect size is greater than (0, 0). 
Failure to do so will result in issues when trying to center the Popup node
using the 'popup_centered' method.
"""

# Signals
signal unlocked

# Child nodes
onready var _audio = $AudioStreamPlayer
onready var _text = $Background/VBoxContainer/DisplayContainer/Glass/Text
onready var _buttons = $Background/VBoxContainer/ButtonContainer
onready var _led = $Background/VBoxContainer/ButtonContainer/LED
onready var _hide_delay = $HideDelay
onready var _incorrect_timer = $IncorrectTimer

# Locked door settings
var is_unlocked = false setget , get_is_unlocked
var _passcode = ""

# SFX
export (Resource) var correct_sound
export (Resource) var button_press

# LED options
export (Resource) var white_light
export (Resource) var red_light
export (Resource) var green_light

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _ready():
	_initialize_buttons()

################################################################################
# PRIVATE METHODS
################################################################################

func _check_passcode():
	if _text.text == _passcode:
		_led.texture = green_light
		_play_sound(correct_sound)
		is_unlocked = true
		_hide_delay.start()
	else:
		_clear_display()
		_led.texture = red_light
		_incorrect_timer.start()

#-------------------------------------------------------------------------------

func _clear_display():
	_text.text = ""

#-------------------------------------------------------------------------------

func _initialize_buttons():
	for child in _buttons.get_children():
		if child is Button:
			child.connect('pressed', self, 'on_Button_pressed', [child.text])

#-------------------------------------------------------------------------------

func _play_sound(stream):
	_audio.stream = stream
	_audio.play()

################################################################################
# PUBLIC METHODS
################################################################################

func set_new_passcode(new_passcode):
	"""
	Args:
		- code (String): Code must be a string of numbers (e.g. 1234).
	"""
	_passcode = new_passcode

################################################################################
# GETTERS
################################################################################

func get_is_unlocked():
	return is_unlocked

################################################################################
# SIGNAL HANDLING
################################################################################

func on_Button_pressed(text):
	_play_sound(button_press)
	
	if text == 'OK':
		_check_passcode()
	else:
		_text.text = _text.text + text

#-------------------------------------------------------------------------------

func _on_Numpad_about_to_show():
	_clear_display()
	_led.texture = white_light

#-------------------------------------------------------------------------------

func _on_HideDelay_timeout():
	emit_signal('unlocked')
	hide()

#-------------------------------------------------------------------------------

func _on_IncorrectTimer_timeout():
	_led.texture = white_light
