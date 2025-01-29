class_name interact_button extends Node

func _ready() -> void:
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	pass