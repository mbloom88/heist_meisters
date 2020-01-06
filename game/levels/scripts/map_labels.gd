extends Control

################################################################################
# PUBLIC METHODS
################################################################################

func toggle_label_visibility():
	for label in get_children():
		label.visible = !label.visible
