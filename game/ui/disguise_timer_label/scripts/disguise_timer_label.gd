extends Label

export (int) var x_offset = 0
export (int) var y_offset = 0

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _ready():
	hide()

################################################################################
# PUBLIC METHODS
################################################################################

func update_label(node, value):
	var node_canvas_position = node.get_global_transform_with_canvas().origin
	
	rect_global_position = Vector2(node_canvas_position.x + x_offset,
		node_canvas_position.y + y_offset)
	
	text = str(value).pad_decimals(2)
