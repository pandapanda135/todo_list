extends interact_button

func _on_pressed() -> void:
	var child_nodes:Array[Node] = get_tree().get_root().get_children()
	if child_nodes.find(self) == -1:
		var parent:Node = get_parent()
		SaveSystem.delete_file("",parent.json_file)
		parent.queue_free()