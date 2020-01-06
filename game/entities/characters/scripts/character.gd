extends KinematicBody2D

# Movement
export (float) var acceleration = 0.0
export (float) var max_speed = 0.0
export (float) var friction = 0.0
var speed = 0
var _motion = Vector2()
