extends Button

var window_scene:Window = preload("res://window_scene.tscn").instantiate()

func _ready() -> void:
	self.pressed.connect(_on_pressed)
	#turn these on for transparent bg and also pixel perfect transparncey
	window_scene.transparent_bg = false
	window_scene.transparent = false

func _on_pressed() -> void:
	var child_nodes:Array[Node] = get_tree().get_root().get_children()
	if child_nodes.find(window_scene) == -1:
		var parent:Node = get_parent()
		SaveSystem.selected_json_file = parent.json_file
		var root = get_tree().get_root()
		root.add_child(window_scene)
	else:
		window_scene.show()