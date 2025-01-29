extends interact_button

signal get_save_file

# I know this is dumb but its too late for thonking
@onready var title_label_display:Label = $"../../../../TitleLabel"
@onready var description_label_display:Label = $"../../../../DescriptionLabel"


@onready var title_label:LineEdit = $"../TitleLabel"
@onready var description_label:TextEdit = $"../DescriptionLabel"

@export var save_note:bool

func _on_pressed() -> void:
	if save_note == true:
		SaveSystem.save_note()
	else:#handles editing title and description
		get_save_file.emit.call()
		var title_label_text:String = title_label.text
		var description_label_text:String = description_label.text
		SaveSystem.change_note(SaveSystem.selected_json_file,0,title_label_text)
		SaveSystem.change_note(SaveSystem.selected_json_file,1,description_label_text)
		SaveSystem.load_note(SaveSystem.selected_json_file,title_label_display,description_label_display)
