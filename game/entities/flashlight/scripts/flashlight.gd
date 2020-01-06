extends Light2D

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _ready():
	change_color('white')

################################################################################
# PUBLIC METHODS
################################################################################

func change_color(new_color):
	"""
	Changes the color of the light.
	
	Args:
		- new_color (String): The new color of the flashlight's light.
			* 'red'
			* 'white'
	"""
	match new_color:
		'red':
			color = Color.red
		'white':
			color = Color.white

#-------------------------------------------------------------------------------

func toggle_light():
	enabled = !enabled
