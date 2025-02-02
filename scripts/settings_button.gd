extends interact_button

func _on_pressed() -> void:
	get_child(0).visible = not get_child(0).visible