extends Area2D

# Child nodes
onready var _sprite = $Sprite

# Collision
export (Array) var _player_collision

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_Loot_body_entered(body):
	if body.collision_layer in _player_collision:
		body.collect_loot(_sprite.texture)
		queue_free()
