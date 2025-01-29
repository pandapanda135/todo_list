extends interact_button

func _on_pressed() -> void:
	OS.shell_open(ProjectSettings.globalize_path("user://"))
