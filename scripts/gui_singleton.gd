extends Node

@onready var collection_1:VFlowContainer = get_parent().get_node("/root/Control/Collection1")
@onready var collection_2:VFlowContainer = get_parent().get_node("/root/Control/Collection2")
@onready var collection_3:VFlowContainer = get_parent().get_node("/root/Control/Collection3")

@onready var collections_array:Array[VFlowContainer] = [collection_1,collection_2,collection_3]

func _ready() -> void:
	print("collections1",collection_1)
	print("collections2",collection_2)
	print("collections3",collection_3)
