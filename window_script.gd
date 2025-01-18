extends Window

@onready var title_node:Label = $Control/ScrollContainer/VBoxContainer/TitleLabel
@onready var description_node:Label = $Control/ScrollContainer/VBoxContainer/DescriptionLabel

#closes window when press close button
func _ready() -> void:
	self.close_requested.connect(_on_close_pressed)
	SaveSystem.load_note(SaveSystem.selected_json_file,title_node,description_node)

func _on_close_pressed() -> void:
	hide()
