extends NinePatchRect

# Child nodes
onready var _text = $RichTextLabel

# JSON
export (String, FILE, "*.json") var json_file
var _dialogue = {}
var _dialogue_index = 0

################################################################################
# BUILT-IN VIRTUAL METHODS
################################################################################

func _ready():
	hide()
	_parse_json_file(json_file)

################################################################################
# PRIVATE METHODS
################################################################################

func _parse_json_file(file_path):
	var file = File.new()
	assert file.file_exists(file_path)
	
	file.open(file_path, file.READ)
	var json = file.get_as_text()
	
	_dialogue = parse_json(json)
	assert _dialogue.size() > 0
	
	file.close()

################################################################################
# PRIVATE METHODS
################################################################################

func next_dialogue():
	_dialogue_index += 1
	
	if str(_dialogue_index) in _dialogue.keys():
		_text.bbcode_text = _dialogue[str(_dialogue_index)]
