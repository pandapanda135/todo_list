extends LineEdit

var saved_text:String= ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text_submitted.connect(_text_submitted)

func _text_submitted(submitted_text) -> void:
	if submitted_text == "":
		print("empty description")
	else:
		saved_text = submitted_text
		save()

func save() -> String:
	var save_String:String = saved_text
	print(save_String)
	return save_String
