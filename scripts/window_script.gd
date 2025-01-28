extends Window

var parent_node:Control

@onready var title_node:Label = $Control/ScrollContainer/VBoxContainer/TitleLabel
@onready var description_node:Label = $Control/ScrollContainer/VBoxContainer/DescriptionLabel

#signal for closing window and handles loading text
func _ready() -> void:
	self.close_requested.connect(_on_close_pressed)
	SaveSystem.load_note(SaveSystem.selected_json_file,title_node,description_node,false,parent_node)

#closes window when press close button
func _on_close_pressed() -> void:
	hide()
