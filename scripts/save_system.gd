extends Node
#@onready var shop_manager: GridContainer = $"../GridContainer"

#may get removed as could cause issues later as the way to add data to var is not made yet
@export var title_node: NodePath
@export var description_node: NodePath
@export var label_title: Label 
@export var label_description: RichTextLabel

var save_amount:int = 0
var save_amount_string:String = str(save_amount)
var save_path:String = "user://note_%s.json" % save_amount_string

# func _ready() -> void:
# 	if FileAccess.file_exists(save_path):
# 		load_note()
# 	else:
# 		pass

#TODO: make it so it makes a new scene from individual_node_test and set the labels in it to what was just made

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

	increment_save_path()

#TODO: this currently parses the last json file in the save_path make it so it can change to something else if needed
func load_note() -> void:
	var file := FileAccess.open(save_path, FileAccess.READ)
	var json := JSON.new()
	var json_line_2 := JSON.new()
	json.parse(file.get_line())
	json_line_2.parse(file.get_line())
	var save_String := json.get_data() as String
	var save_String_2 := json_line_2.get_data() as String

	print(save_String)
	print(save_String_2)

	#temporary for test purposes
	label_title.text = save_String
	label_description.text = save_String_2


func increment_save_path() -> void:
	save_amount += 1
	save_amount_string = str(save_amount)
	save_path = "user://note_%s.json" % save_amount_string
	print("save ",save_amount)
	print("save amount string ",save_amount_string)
	print("path ",save_path)