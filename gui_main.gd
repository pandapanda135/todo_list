extends Control
@onready var collection_1_local: VFlowContainer = $Collection1
@onready var collection_2_local: VFlowContainer = $Collection2
@onready var collection_3_local: VFlowContainer = $Collection3

func _ready() -> void:
	# print(collection_1_local)
	# Gui.collection_1 = collection_1_local
	# Gui.collection_2 = collection_2_local
	# Gui.collection_3 = collection_3_local
	Gui.initialize_variables(collection_1_local,collection_2_local,collection_3_local)
