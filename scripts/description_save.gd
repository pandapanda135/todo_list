extends text_manager

func save() -> String:
	var save_String_2:String = self.text
	self.text = ""
	print(save_String_2)
	return save_String_2