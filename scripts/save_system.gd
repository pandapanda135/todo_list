extends Node
#@onready var shop_manager: GridContainer = $"../GridContainer"

#may get removed as could cause issues later as the way to add data to var is not made yet
@export var title_node: NodePath
@export var description_node: NodePath

# we use onready or else load_note doesnt work due to them not being initialized correctly (I know the code is bad but its all that works :( )
@onready var label_title: Label = get_parent().get_node("/root/Control/Label")
@onready var label_description: RichTextLabel = get_parent().get_node("/root/Control/RichTextLabel")

var save_amount:int = 0
var save_amount_string:String = str(save_amount)
var save_path:String = "user://note_%s.json" % save_amount_string
#this will be used for selecting note to load and delete DirAccess.remove_absolute(formated_path)
var selected_save_file_string:String = "0"
var selected_save_file:String = "user://note_%s.json" % selected_save_file_string 

# func _ready() -> void:
# 	if FileAccess.file_exists(save_path):
# 		load_note()
# 	else:
# 		pass

#this will be used to add the nodes to the scene incase notes are in the files however not represented as nodes
#make system to keep value of largest node made so it doesnt need to loop through and array because if someone deletes more than two files this system breaks and its dumb and save it as var? can use save_amount for this 
# that feels dumb though so maybe find a way to where it can find the largest number in a note file than iterate that many times through a for loop however this is hard considering they are stored as strings
func _ready() -> void:
	# this is used to find the amount of files in dir stole from offical documentation (this will be removed for one of the methods described above)
	var dir = DirAccess.open("user://")
	var file_name_array:Array[String]
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				file_name_array.append(file_name)
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	var node_packed_scene:PackedScene = preload("res://individual_node_test.tscn")
	var node_scene = node_packed_scene.instantiate()
	var root = get_tree().get_root()
	var run:int = 0
	for i in file_name_array.size():
		node_scene.json_file = "user://note_%s.json" % run
		node_scene.name = "node_note: %s" % run
		if FileAccess.file_exists("user://note_%s.json" % run):
			print("user://note_%s.json" % run)
			root.add_child.call_deferred(node_scene)
			print("FileAccess work")
		else:
			print("FileAccess null")
		run += 1
		print("node scene name ",node_scene.name)

#TODO: make it so it makes a new scene from individual_node_test and set the labels in it to what was just made

func save_note() -> void:
	var save_file := FileAccess.open(save_path, FileAccess.WRITE)
	var save_nodes_persist := get_tree().get_nodes_in_group("persist")
	for node:Node in save_nodes_persist:
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

#TODO: this currently parses save_path however as save_path looks for the next file it crashes the program so make it so the  user can decide the file and not base it off if save path (done now)
func load_note(selected_id) -> void:
	selected_save_file_string = selected_id
	selected_save_file = "user://note_%s.json" % selected_save_file_string
	print(selected_save_file) 
	var file := FileAccess.open(selected_save_file, FileAccess.READ) 
	var json := JSON.new()
	var json_line_2 := JSON.new()
	json.parse(file.get_line())
	json_line_2.parse(file.get_line())
	var save_String := json.get_data() as String
	var save_String_2 := json_line_2.get_data() as String

	print(save_String)
	print(save_String_2)

	#temporary for test purposes
	if label_title == null and label_description == null:
		print("nodes not initialized")
	else:
		label_title.text = save_String
		label_description.text = save_String_2

func delete_selected_file(save_string) -> void:
	selected_save_file_string = save_string
	selected_save_file = "user://note_%s.json" % selected_save_file_string 

	if DirAccess.remove_absolute(selected_save_file) == 1:
		print("this does not exist")
	else:
		DirAccess.remove_absolute(selected_save_file)
		print("remove successful")

func increment_save_path() -> void:
	save_amount += 1
	save_amount_string = str(save_amount)
	save_path = "user://note_%s.json" % save_amount_string
	print("save ",save_amount)
	print("save amount string ",save_amount_string)
	print("path ",save_path)

var save_amount_nodes:int = 0
var save_amount_string_nodes:String = str(save_amount)
var save_path_nodes:String = "user://node_%s.json" % save_amount_string

func save_nodes() -> void:
	var save_file := FileAccess.open(save_path, FileAccess.WRITE)
	var save_persist_nodes := get_tree().get_nodes_in_group("persist_nodes")
	for node:Node in save_persist_nodes:
		# Check the node is an instanced cene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function. This is a string as with the scope of the project we should only store text
		var node_data:Node = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string:String = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.s
		save_file.store_line(json_string)


func load_node() -> void:
	pass

var save_path_variables:String = "user://variables.json"

func save_variables() -> void:
	var save_file := FileAccess.open(save_path_variables, FileAccess.WRITE)
	var save_nodes_persist := get_tree().get_nodes_in_group("persist_config")
	for node:Node in save_nodes_persist:

		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		var node_data:int = node.call("save")

		var json_string:String = JSON.stringify(node_data)

		save_file.store_line(json_string)

func load_variables() -> void: 
	var file := FileAccess.open(save_path_variables, FileAccess.READ) 
	var json := JSON.new()
	json.parse(file.get_line())
	var save_int := json.get_data() as int

	print(save_int)

	save_amount = save_int


func save() -> int:
	var save_int:int = save_amount
	print(save_int)	
	return save_int
