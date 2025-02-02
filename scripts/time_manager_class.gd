class_name text_manager extends Node

var saved_text:String = ""
var regex:RegEx = RegEx.new()
func _ready() -> void:
	self.text_changed.connect(_text_changed)
	regex.compile(r"^\d+$")

func _text_changed(submitted_text) -> void:
	print("ASSIGN _TEXT_CHANGED",submitted_text)
	pass