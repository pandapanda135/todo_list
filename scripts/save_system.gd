extends Node

signal load_node_signal

@onready var control:Control = get_parent().get_node("/root/Control")

var save_amount:int = 0
var save_amount_string:String = str(save_amount)
var save_path:String = "user://note_%s.json" % save_amount_string

var selected_save_file_string:String = "0"
var selected_save_file:String = "user://note_%s.json" % selected_save_file_string

var selected_json_file:String

var check_save_amount_correct:bool = true

var save_cooldown:int = 300

const NOTE_NODE:String = "res://scenes/individual_node_test.tscn"
const SAVE_PATH_VARIABLES:String = "user://variables.json"

func _ready() -> void:
	if FileAccess.file_exists(SAVE_PATH_VARIABLES):
		print("variables file exists")
		var variables_value:Dictionary = load_variables()
		save_amount = variables_value["save_amount"]
		save_cooldown = variables_value["save_cooldown"]
	else:
		print("variables file doesnt exist")
		save_variables() # make variables file if doesnt exist

	# this is used to find the amount of files in dir
	var dir:DirAccess = DirAccess.open("user://")
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
	self.connect("load_node_signal",load_node)
	load_node_signal.emit()

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

			if node_data is String and node_data == "":
				print("a '%s' is the group persist has a null value" % node)
				return

			# JSON provides a static method to serialized JSON string.
			var json_string:String = JSON.stringify(node_data)
			print("THIS iS JSON_STRING",json_string)

			# Store the save dictionary as a new line in the save file.
			save_file.store_line(json_string)

		save_file.close()
		add_and_change_made_nodes(save_amount,true)
		increment_save_path()
		print("done")
	else:
		print("check_save_amount_correct is set to false")

func load_reusable(save_file:String,line_4_index:int = -1,load_line_4:bool = false) -> Dictionary: # ?when next godot version out update all references of this to use typed dictionaries
	var file := FileAccess.open(save_file, FileAccess.READ)
	print("file_read_1",file)
	var json := JSON.new()
	var json_line_2 := JSON.new()
	var json_line_3 := JSON.new()
	var json_line_4 := JSON.new()
	json.parse(file.get_line())
	json_line_2.parse(file.get_line())
	json_line_3.parse(file.get_line())
	json_line_4.parse(file.get_line())

	if load_line_4 == true:
		pass
	else:
		var file_write := FileAccess.open(save_file, FileAccess.WRITE)
		print("write",file_write)
		for i:int in range(0,4):
			match i:# should make it so it doesnt overwrite the file with nothing but the new index this is because otherwise the fourth line is not populated and crash
				0:
					var json_string = JSON.stringify(json.get_data() as String)
					file_write.store_line(json_string)
				1:
					var json_string = JSON.stringify(json_line_2.get_data() as String)
					file_write.store_line(json_string)
				2:
					var json_string = JSON.stringify(json_line_3.get_data() as int)
					file_write.store_line(json_string)
				3:
					var json_string = JSON.stringify(line_4_index as int)
					file_write.store_line(json_string)
		file_write.close()
		file = FileAccess.open(save_file, FileAccess.READ)

	json.parse(file.get_line())
	json_line_2.parse(file.get_line())
	json_line_3.parse(file.get_line())
	json_line_4.parse(file.get_line())

	return {
		"save_string": json.get_data() as String,
		"save_string_2": json_line_2.get_data() as String,
		"save_int": json_line_3.get_data() as int,
		"save_int_2": json_line_4.get_data() as int
	}

func save_overwrite(save_file:String,dict:Dictionary) -> void:
	DirAccess.remove_absolute(save_file)
	var save_file_select:FileAccess = FileAccess.open(save_file, FileAccess.WRITE)
	for key in dict:
		if dict[key] is String and dict[key] == "":
			print("EMPTY STRING OR SOMETHING OR BIG MISTAKE AAAAA")
			return

		var json_string:String = JSON.stringify(dict[key])

		save_file_select.store_line(json_string)

func load_note(save_file:String,label_title:Node,label_description:Node,is_from_save:bool = false,node_arg:Control = null) -> void:
	print("save_file",save_file)
	var current_index:int
	if node_arg != null:
		current_index = node_arg.call("save")
	var value:Dictionary
	if is_from_save == true: # is_from_save is also used in add_or_change_node to see if this is being called from save_note I know its bad and I also hate it but it works and I already made a mistake adding index saving
		value = load_reusable(save_file,current_index,false)
	else:
		value = load_reusable(save_file,current_index,true)

	print(value["save_string"])
	print(value["save_string_2"])

	#temporary for test purposes
	if label_title == null and label_description == null:
		print("nodes not initialized")
	else:
		label_title.text = value["save_string"]
		label_description.text = value["save_string_2"]

func delete_file(note_string:String = "",json_file:String = "") -> void: # note_string used for int as string json_file used for full file path
	var save_file:String
	if note_string != "":
		save_file = "user://note_%s.json" % note_string
	else:
		save_file = json_file

	if DirAccess.remove_absolute(save_file) == 1:
		print("this does not exist")
	else:
		DirAccess.remove_absolute(save_file)
		print("remove successful")

func change_note(save_file:String,line_change:int,string_change:String = "",int_change:int = -1) -> void:
	var value:Dictionary = load_reusable(save_file)
	match line_change:
		0:
			value["save_string"] = string_change
		1:
			value["save_string_2"] = string_change
		2:
			value["save_int"] = int_change
		3:
			value["save_int_2"] = int_change
		_:
			printerr("line_change is too high")
	save_overwrite(save_file,value)

func add_and_change_made_nodes(save_number:int,is_from_save:bool = false) -> void:
	save_number = load_container("user://note_%s.json" % save_number)
	var node_scene:Control = preload(NOTE_NODE).instantiate()
	var first_child:Node = node_scene.get_child(0) # ? change this later because I dont like as this means title and description node need to always have their respective index
	var second_child:Node = node_scene.get_child(1)

	match save_number:
		0:
			Gui.collection_1.add_child(node_scene)
		1:
			Gui.collection_2.add_child(node_scene)
		2:
			Gui.collection_3.add_child(node_scene)
		_:
			print("issue with value int ",save_number)

	node_scene.json_file = "user://note_%s.json" % save_number
	node_scene.name = "node_note:%s" % save_number
	if is_from_save == true:
		load_note(node_scene.json_file,first_child,second_child,true,node_scene)
	else:
		load_note(node_scene.json_file,first_child,second_child,false,node_scene)

#load container position from file
func load_container(save_file:String) -> int:
	var file := FileAccess.open(save_file, FileAccess.READ)
	var json := JSON.new()
	var save_int:int
	for i in range(0,3):
		json.parse(file.get_line())
		save_int = json.get_data() as int
	return save_int

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
	save_system_reuseable_base(save_path,"persist_nodes") #used for getting node index

#primarily handles correctly setting node position in parent
func load_node() -> void:
	var child_nodes_collection:Array[Node] = Gui.collection_1.get_children() + Gui.collection_2.get_children() + Gui.collection_3.get_children()
	for node:Node in child_nodes_collection:
		var load_values:Dictionary = load_reusable(node.json_file,-1,true)
		match node.get_parent():
			Gui.collection_1:
				Gui.collection_1.move_child(node,load_values["save_int_2"])
			Gui.collection_2:
				Gui.collection_2.move_child(node,load_values["save_int_2"])
			Gui.collection_3:
				Gui.collection_3.move_child(node,load_values["save_int_2"])
		node.node_made.emit() # should fix issues with arrows not being correctly disabled

# handles variables file
func save_variables(save_time = false) -> void:
	var save_file := FileAccess.open(SAVE_PATH_VARIABLES, FileAccess.WRITE)
	var json_string:String = str(save_amount)
	for line:int in range(2):
		if line == 0 and save_time == false:
			json_string = JSON.stringify(save_amount + 1)
		elif line == 1:
			json_string = JSON.stringify(save_cooldown)

		save_file.store_line(json_string)

func load_variables() -> Dictionary:
	var file := FileAccess.open(SAVE_PATH_VARIABLES, FileAccess.READ)
	var json := JSON.new()
	var json_2 := JSON.new()
	json.parse(file.get_line())
	json_2.parse(file.get_line())
	var save_int := json.get_data() as int
	var save_time := json_2.get_data() as int

	return{
		"save_amount": save_int,
		"save_cooldown": save_time
	}

func save() -> int:
	print(save_amount)
	return save_amount

func correct_save_path() -> void:
	save_amount_string = str(save_amount)
	save_path = "user://note_%s.json" % save_amount_string

func increment_save_path() -> void:
	save_variables()
	save_amount += 1
	save_amount_string = str(save_amount)
	save_path = "user://note_%s.json" % save_amount_string
	print("save ",save_amount)
	print("save amount string ",save_amount_string)
	print("path ",save_path)