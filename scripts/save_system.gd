extends Node
#@onready var shop_manager: GridContainer = $"../GridContainer"

#may get removed as could cause issues later as the way to add data to var is not made yet
@export var title_node: NodePath
@export var description_node: NodePath


var save_amount:int = 0
var save_amount_string:String = str(save_amount)
var save_path_no_int:String = "user://note_%s.json"
var save_path:String = save_path_no_int % save_amount_string

# func _ready() -> void:
# 	if FileAccess.file_exists(save_path):
# 		load_game()
# 	else:
# 		pass
# 	print(save_path)

func save_game() -> void:
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

		# Call the node's save function.
		var node_data:Node = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string:String = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)

func load_game() -> void:
	var file := FileAccess.open(save_path, FileAccess.READ)
	var json := JSON.new()
	var json_2 := JSON.new()
	var json_3 := JSON.new()
	json.parse(file.get_line())
	json_2.parse(file.get_line())
	json_3.parse(file.get_line())
	#var save_dict := json.get_data() as Dictionary
	#var save_array := json_2.get_data() as Array
	var save_String := json_2.get_data() as String

	# str_to_var can be used to convert a String to the corresponding Variant.
	# Currency.money = (save_dict.Currency)
	# Currency.click_amount = (save_dict.click_amount)
	# Currency.shop_1 = (save_dict.shop_1_amount)
	# Currency.shop_2 = (save_dict.shop_2_amount)
	# Currency.shop_3 = (save_dict.shop_3_amount)
	# Currency.total_shops = (save_dict.total_shops)
	# Currency.total_upgrades = (save_dict.total_upgrades)

	# shop_manager.price_array[0] = save_array[0]
	# shop_manager.price_array[1] = save_array[1]
	# shop_manager.price_array[2] = save_array[2]
#maybe use a function in shop_controller to update labels
