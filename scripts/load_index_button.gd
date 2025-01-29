extends interact_button

func _on_pressed() -> void:
	SaveSystem.load_node_signal.emit()
