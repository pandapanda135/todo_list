extends text_manager

func save() -> String:
	print("ThIS iS THE SAVE TEXT",saved_text)
	var save_string:String = self.text
	self.text = ""
	return save_string
