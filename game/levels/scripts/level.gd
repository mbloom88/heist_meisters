extends Node2D

# Child nodes
onready var _extraction = $ExtractionPoint
onready var _vision = $VisionMode
onready var _loot = $Loot
onready var _map_labels = $MapLabels

# Level
export (String) var next_level = ""

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _ready():
	_initialize()

################################################################################
# PRIVATE METHODS
################################################################################

func _initialize():
	_map_labels.toggle_label_visibility()
	get_tree().call_group('computers', 'assign_new_passcode')
	get_tree().call_group('player', 'update_disguise_count')
	_extraction.loot_goal = _loot.get_child_count()

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_ExtractionPoint_loot_goal_achieved():
	get_tree().call_group('game_master', 'show_victory', next_level)

#-------------------------------------------------------------------------------

func _on_Player_vision_toggled():
	_vision.cycle_through_visions()
	_map_labels.toggle_label_visibility()
