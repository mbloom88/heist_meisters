extends Popup

# Child nodes
onready var _text = $Background/Screen/Glass/ScreenText

################################################################################
# PRIVATE METHODS
################################################################################

func _clear_display():
	_text.text = ""

################################################################################
# PUBLIC METHODS
################################################################################

func set_screen_text(text):
	"""
	"""
	_text.bbcode_text = text
