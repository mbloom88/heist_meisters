extends ColorRect

# Signals 
signal loot_goal_achieved

# Loot
var loot_goal = 0 setget set_loot_goal

# Collision
export (Array) var _player_collision

################################################################################
# SETTERS
################################################################################

func set_loot_goal(value):
	loot_goal = value # int

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_Area2D_body_entered(body):
	if body.collision_layer in _player_collision:
		if body.loot_total == loot_goal:
			emit_signal('loot_goal_achieved')
