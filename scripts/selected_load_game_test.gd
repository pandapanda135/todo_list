extends LineEdit

var submitted_id:String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text_submitted.connect(_text_submitted)

func _text_submitted(added_id) -> void:
	submitted_id = added_id
	#SaveSystem.load_note(submitted_id) #TODO: fix this so it works with new args ( or just remove this file as its not really needed anymore)
