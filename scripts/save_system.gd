extends Node

# we use onready or else load_note doesnt work due to them not being initialized correctly (I know the code is bad but its all that works :( )
@onready var label_title_node: Label = get_parent().get_node("/root/Control/TitleLabel")
@onready var label_description_node: Label = get_parent().get_node("/root/Control/DescriptionLabel")

@onready var control = get_parent().get_node("/root/Control")

@onready var save_path_variables:String = "user://variables.json"

var save_amount:int = 0
var save_amount_string:String = str(save_amount)
var save_path:String = "user://note_%s.json" % save_amount_string
#this will be used for selecting note to load and delete DirAccess.remove_absolute(formated_path)
var selected_save_file_string:String = "0"
var selected_save_file:String = "user://note_%s.json" % selected_save_file_string

var selected_json_file

var check_save_amount_correct:bool = true

#this will be used to add the nodes to the scene incase notes are in the files however not represented as nodes
#make system to keep value of largest node made so it doesnt need to loop through and array because if someone deletes more than two files this system breaks and its dumb and save it as var? can use save_amount for this 
# that feels dumb though so maybe find a way to where it can find the largest number in a note file than iterate that many times through a for loop however this is hard considering they are stored as strings
func _ready() -> void:
	if FileAccess.file_exists(save_path_variables):
		load_variables()
	else:
		pass

	# this is used to find the amount of files in dir stole from offical documentation (this will be removed for one of the methods described above) (it might not be removed)
	var dir = DirAccess.open("user://")
	var file_name_array:Array[String]
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir(): #remove this eventually as we dont need dir we only need files
				print("Found directory: " + file_name)
			else:
				file_name_array.append(file_name)
				print("Found file: " + file_name)
				print(len(file_name_array))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	if save_amount != 0 and len(file_name_array) != 0: #ugly disgusting if statment but theres too many potential edge cases with these files so I guess it works
		for i in save_amount:
			if FileAccess.file_exists("user://note_%s.json" % i):
				print("ABOUT TO RUN ADD_AND_CHANGE",i)
				add_and_change_made_nodes(i)
			else:
				print("user://note_%s.json doesnt exist" % i)
	elif save_amount == 0 and len(file_name_array) - 1 == 0: # this is here so on first boot there shouldnt be any warnings
		print("first boot?")
	elif save_amount == 0 and len(file_name_array) - 1 > 0:
		printerr("this error is because file name array is larger than one and save amount = 0 which indicates there is an issue with the variables file")
		check_save_amount_correct = false
		OS.shell_open(ProjectSettings.globalize_path("user://"))
	elif len(file_name_array) - 1 > save_amount:
		print("issues with amount len(file_name_array) - 1")
		OS.shell_open(ProjectSettings.globalize_path("user://"))
	else:
		printerr("issues with if in _ready")
		check_save_amount_correct = false
		OS.shell_open(ProjectSettings.globalize_path("user://"))

func save_note() -> void:
	print("save_amount: ",save_path)
	correct_save_path()
	var save_file := FileAccess.open(save_path, FileAccess.WRITE)
	var save_nodes_persist := get_tree().get_nodes_in_group("persist")
	if check_save_amount_correct == true:
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
			var node_data = node.call("save")

			# JSON provides a static method to serialized JSON string.
			var json_string:String = JSON.stringify(node_data)
			print("THIS iS JSON_STRING",json_string)

			# Store the save dictionary as a new line in the save file.
			save_file.store_line(json_string)

		 #cant have this here as I think the file doesnt save until after the function is finished so load_note cant read the lines it needs
		save_file.close()
		add_and_change_made_nodes(save_amount)
		increment_save_path()
		print("done")
	else:
		print("check_save_amount_correct is set to false")

#TODO: Make save_int do stuff for lodaing
func load_note(save_file:String,label_title:Node,label_description:Node) -> void:
	# selected_save_file_string = selected_id
	# selected_save_file = "user://note_%s.json" % selected_save_file_string
	print("save_file",save_file)
	var file := FileAccess.open(save_file, FileAccess.READ)
	var json := JSON.new()
	var json_line_2 := JSON.new()
	var json_line_3 := JSON.new()
	json.parse(file.get_line())
	json_line_2.parse(file.get_line())
	json_line_3.parse(file.get_line())
	var save_String := json.get_data() as String
	var save_String_2 := json_line_2.get_data() as String
	# var save_int := json_line_3.get_data() as int

	print(save_String)
	print(save_String_2)

	#temporary for test purposes
	if label_title == null and label_description == null:
		print("nodes not initialized")
	else:
		label_title.text = save_String
		label_description.text = save_String_2

var value_int:int
func add_and_change_made_nodes(save_number:int) -> void:
	load_container("user://note_%s.json" % save_number)
	# var root:Node = get_tree().get_root()
	var node_scene:Control = preload("res://individual_node_test.tscn").instantiate() #hard coded and bad incase I want to use other type of node but it works at its probably going to stay this way
	var first_child:Node = node_scene.get_child(0)
	var second_child:Node = node_scene.get_child(1)

	# root.add_child.call_deferred(node_scene)
	match value_int:
		0:
			Gui.collection_1.add_child.call_deferred(node_scene)
		1:
			Gui.collection_2.add_child.call_deferred(node_scene)
		2:
			Gui.collection_3.add_child.call_deferred(node_scene)
		_:
			print("BIG ISSUE WITH VALUE_INT ",value_int)

	node_scene.json_file = "user://note_%s.json" % save_number
	node_scene.name = "node_note:%s" % save_number
	load_note(node_scene.json_file,first_child,second_child)

#load container position from file
func load_container(save_file:String) -> void:
	var file := FileAccess.open(save_file, FileAccess.READ)
	var json := JSON.new()
	var save_int:int
	for i in range(0,3):
		json.parse(file.get_line())
		save_int = json.get_data() as int
	print("LOAD_CONTAINOR save_int ",save_int)
	value_int = save_int

func delete_selected_file(save_string:String) -> void:
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
	save_variables()

var save_amount_nodes:int = 0
var save_amount_string_nodes:String = str(save_amount)
var save_path_nodes:String = "user://node_%s.json" % save_amount_string

func save_system_reuseable_base(file_path:String,group_name:String) -> void:
	var save_file := FileAccess.open(file_path, FileAccess.WRITE)
	var save_nodes_persist := get_tree().get_nodes_in_group(group_name)
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

func save_nodes() -> void:
	save_system_reuseable_base(save_path,"persist_nodes")

#this is probably need to be used when more ui/ux aspects are implemented
func load_node() -> void:
	pass

func save_variables() -> void:
	var save_file := FileAccess.open(save_path_variables, FileAccess.WRITE)

	var node_data:int = save_amount

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

func correct_save_path() -> void:
	if DirAccess.open(save_path_variables) != null: #checks if save_path_variables exits this is so it fixes and issue or something idk what this does tbh
		print("correct_save_path first if")
		save_amount += 1
		save_variables()
	else:
		print("correct_save_path second if")
		load_variables()
	save_amount_string = str(save_amount)
	save_path = "user://note_%s.json" % save_amount_string
