extends LineEdit

var saved_text:String
# var save_String:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text_submitted.connect(_text_submitted)

func _text_submitted(submitted_text) -> void:
	print("THIS IS ThE SUBMITTED TEXT",submitted_text)
	if submitted_text == "" or self.text == "":
		print("empty description")
	else:
		saved_text = submitted_text
		save()

func save() -> String:
	print("ThIS iS THE SAVE TEXT",saved_text)
	var save_String:String = saved_text
	saved_text = ""
	print("THIS IS SAVE STRING",save_String)
	return save_String
