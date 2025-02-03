extends LineEdit

#? this is old and was used for debugging to manually remove a specific save file
var submitted_id:String = ""

func _ready() -> void:
	self.text_submitted.connect(_text_submitted)

func _text_submitted(added_id) -> void:
	submitted_id = added_id
	SaveSystem.delete_file(submitted_id)