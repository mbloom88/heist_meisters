extends "res://levels/scripts/level.gd"

# Child nodes
onready var _lighting = $Lighting
onready var _pointer = $ObjectivePointer
onready var _markers = $ObjectiveMarkers
onready var _areas = $ObjectiveAreas
onready var _tutorial_text = $GUI/TutorialTextContainer

# Objectives
var _objective_positions = []

################################################################################
# BUILT-IN VIRTUAL FUNCTIONS
################################################################################

func _ready():
	_next_objective()
	_tutorial_text.show()

#-------------------------------------------------------------------------------

func _next_objective():
	var next_location = _markers.get_child(0).global_position
	_pointer.move_to_location(next_location)
	_tutorial_text.next_dialogue()

#-------------------------------------------------------------------------------

func _remove_objective_area():
	var area = null
	area = _areas.get_child(0)
	_areas.remove_child(area)
	area.queue_free()

#-------------------------------------------------------------------------------

func _remove_objective_marker():
	var marker = null
	marker = _markers.get_child(0)
	_markers.remove_child(marker)
	marker.queue_free()

#-------------------------------------------------------------------------------

func _toggle_lighting():
	for light in _lighting.get_children():
		light.enabled = !light.enabled

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_ObjectiveArea_body_entered(body):
	if body.collision_layer in [1, 8]:
		if _areas.get_children():
			_remove_objective_area()
			
		if _markers.get_children():
			_next_objective()

#-------------------------------------------------------------------------------

func _on_ObjectivePointer_move_completed():
	if _markers.get_children():
		_remove_objective_marker()

#-------------------------------------------------------------------------------

func _on_Player_vision_toggled():
	_vision.cycle_through_visions()
	_map_labels.toggle_label_visibility()
	_toggle_lighting()
