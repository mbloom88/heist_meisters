extends Node2D

# Child nodes
onready var _anim = $Pivot/AnimationPlayer
onready var _body = $Pivot/Body

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _ready():
	_initialize()

################################################################################
# PRIVATE METHODS
################################################################################

func _initialize():
	_anim.play('scan')

################################################################################
# PUBLIC METHODS
################################################################################

func toggle_flashlight():
	_body.toggle_flashlight()
