extends NinePatchRect

# Child nodes
onready var _meter = $CenterContainer/HBoxContainer/Meter
onready var _suspicion_decay = $SuspicionDecayTimer

# Suspicion
export (float) var gain = 0
export (float) var decay = 0
export (float) var decay_rate

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _ready():
	_initialize()

################################################################################
# PRIVATE METHODS
################################################################################

func _initialize():
	_meter.value = 0
	_meter.step = gain
	_suspicion_decay.wait_time = decay_rate

################################################################################
# PUBLIC METHODS
################################################################################

func player_sighted():
	_meter.value += gain
	
	if _meter.value == _meter.max_value:
		pass

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_SuspicionDecayTimer_timeout():
	if _meter.value > 0:
		_meter.value -= decay
