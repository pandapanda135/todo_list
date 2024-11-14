extends Node

var saved_text:String= ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#self.text_submitted.connect(_text_submitted)
	self.text_changed.connect(_on_text_changed)
	pass

func node_handler() -> void:
	if is_class("TextEdit"):
		print("TextEdit")
		pass
	else:
		print("Not TextEdit")
		pass

# func _text_submitted(submitted_text) -> void:
# 	saved_text = submitted_text
# 	save()
# 	print(submitted_text)

func _on_text_changed() -> void:
	saved_text = $".".text
	save()

func save() -> String:
	var save_String:String = saved_text
	print(save_String)	
	return save_String