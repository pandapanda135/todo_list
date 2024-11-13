extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text_submitted.connect(_text_submitted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _text_submitted(submitted_text) -> void:
	save(submitted_text)
	#SaveSystem.save_game()
	print(submitted_text)

func save(text_save) -> String:
	var save_String:String = text_save
	print(save_String)	
	return save_String
