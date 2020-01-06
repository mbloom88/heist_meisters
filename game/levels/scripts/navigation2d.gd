extends Navigation2D

# Child nodes
onready var _destinations = $Destinations

################################################################################
# PUBLIC METHODS
################################################################################

func provide_destinations():
	var position2d_list = _destinations.get_children()
	var destinations = []
	
	for point in position2d_list:
		destinations.append(point.position)
	
	return destinations
