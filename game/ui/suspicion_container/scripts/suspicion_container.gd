extends NinePatchRect

# Signals
signal suspicion_maxed

# Child nodes
onready var _meter = $CenterContainer/HBoxContainer/Meter
onready var _suspicion_decay = $SuspicionDecayTimer

# Suspicion
export (float) var gain = 0
export (float) var decay = 0
export (float) var decay_rate
var _has_suspicion_maxed = false

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
	if not _has_suspicion_maxed:
		_meter.value += gain
	
		if _meter.value == _meter.max_value:
			_has_suspicion_maxed = true
			get_tree().call_group('game_master', 'show_game_over')

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_SuspicionDecayTimer_timeout():
	if _meter.value > 0:
		_meter.value -= decay
