extends Node
#@onready var shop_manager: GridContainer = $"../GridContainer"

#may get removed as could cause issues later as the way to add data to var is not made yet
@export var title_node: NodePath
@export var description_node: NodePath


var save_amount:int = 0
var save_amount_string:String = str(save_amount)
var save_path:String = "user://note_%s.json" % save_amount_string

# func _ready() -> void:
# 	if FileAccess.file_exists(save_path):
# 		load_game()
# 	else:
# 		pass
# 	print(save_path)

func save_note() -> void:
	var save_file := FileAccess.open(save_path, FileAccess.WRITE)
	var save_nodes := get_tree().get_nodes_in_group("persist")
	for node:Node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function. This is a string as with the scope of the project we should only store text
		var node_data:String = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string:String = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)

func load_note() -> void:
	var file := FileAccess.open(save_path, FileAccess.READ)
	var json := JSON.new()
	json.parse(file.get_line())
	var save_String := json.get_data() as String
