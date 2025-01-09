extends Node

@onready var collection_2:VFlowContainer
@onready var collection_3:VFlowContainer
@onready var collection_1:VFlowContainer

@onready var collections_array:Array[VFlowContainer]

func _ready() -> void:
	pass

func _process(delta):
	pass

#this is so because it was easier than other meathods despite it being dumb
#collections_array will be used to move them from collection to collection
func initialize_variables(value_1,value_2,value_3) -> void:
	collection_1 = value_1
	collection_2 = value_2
	collection_3	= value_3
	collections_array = [collection_1,collection_2,collection_3]
	print(collection_1)
	print(collection_2)
	print(collection_3)
	print(collections_array)