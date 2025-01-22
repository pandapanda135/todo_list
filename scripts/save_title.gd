extends LineEdit

#TODO: when the save function is called it overwrites saved_text meaning it is "" (THIS IS FIXED BECUASE THE GROUP SYSTEM IS DUMB)
var saved_text:String = "THIS IS THE DEFAULT VALUE"

func _ready() -> void:
	self.text_changed.connect(_text_changed)

func _text_changed(submitted_text) -> void:
	if submitted_text == "" or self.text == "":
		print("empty description")
	else:
		print("_text_submitted ",submitted_text)
		saved_text = submitted_text

func save() -> String:
	print("ThIS iS THE SAVE TEXT",saved_text)
	var save_string:String = saved_text
	saved_text = ""
	return save_string
