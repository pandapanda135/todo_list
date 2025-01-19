extends Node

var saved_text:String= ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text_changed.connect(_on_text_changed)

func _on_text_changed() -> void:
	if self.text == "":
		print("empty description")
	else:
		saved_text = self.text

func save() -> String:
	var save_String_2:String = saved_text
	saved_text = ""
	print(save_String_2)
	return save_String_2