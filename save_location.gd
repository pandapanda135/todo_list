extends Button

func _ready() -> void:
	self.pressed.connect(_on_pressed)
	#Don't allow loading files that don't exist yet.
	#($SaveLoad/LoadConfigFile as Button).disabled = not FileAccess.file_exists("user://save_config_file.ini")
	($"." as Button).disabled = not FileAccess.file_exists("user://note_0.json")


func _on_pressed() -> void:
	OS.shell_open(ProjectSettings.globalize_path("user://"))
