extends text_manager

func _text_changed(submitted_text) -> void:
	var result:RegExMatch = regex.search(submitted_text)
	if submitted_text == "" or result == null:
		self.text = ""
		print("empty or bad")
	else:
		print("_text_submitted ",submitted_text)
		saved_text = submitted_text
