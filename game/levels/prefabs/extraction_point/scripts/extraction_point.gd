extends ColorRect

# Loot goal
export (int) var loot_goal = 0

# Collision
export (Array) var _player_collision

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_Area2D_body_entered(body):
	if body.collision_layer in _player_collision:
		if body.loot_total == loot_goal:
			get_tree().quit()
