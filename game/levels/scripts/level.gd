extends Node2D

# Child nodes
onready var _vision = $VisionMode
onready var _map_labels = $MapLabels

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _ready():
	_map_labels.toggle_label_visibility()
	get_tree().call_group('computers', 'assign_new_passcode')
	get_tree().call_group('player', 'update_disguise_count')

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_Player_vision_toggled():
	_vision.cycle_through_visions()
	_map_labels.toggle_label_visibility()
