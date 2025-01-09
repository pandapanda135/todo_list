extends Control

@onready var arrow_handler:Control = $ArrowHandler

@onready var up_arrow: Button = $ArrowHandler/UpArrow
@onready var right_arrow: Button = $ArrowHandler/RightArrow
@onready var down_arrow: Button = $ArrowHandler/DownArrow
@onready var left_arrow: Button = $ArrowHandler/LeftArrow

@export var json_file:String = ""

#these are here to stop a warning because it was annoying
var up_arrow_signal: int
var left_arrow_singal: int
var right_arrow_signal: int
var down_arrow_signal: int

func _ready():
	up_arrow_signal = up_arrow.pressed.connect(check_node_position.bind(up_arrow))
	left_arrow_singal = left_arrow.pressed.connect(check_node_position.bind(left_arrow))
	right_arrow_signal = right_arrow.pressed.connect(check_node_position.bind(right_arrow))
	down_arrow_signal = down_arrow.pressed.connect(check_node_position.bind(down_arrow))

func slider_changed(value, node):
	print_debug(value, ' ', node)

func check_node_position(clicked_node) -> void:
	print("running move_node with",clicked_node)
	match clicked_node:
		up_arrow:
			print(up_arrow,"was used in signal")
			#dont modify until make system to move up in tree
			match self.get_parent():
				Gui.collection_1:
					print("asld")
				Gui.collection_2:
					print("asfgjfsgjfgsj")
				Gui.collection_3:
					print("FGDHFGSDHFGH")
		left_arrow:
			move_match(self,Gui.collections_array[2],Gui.collections_array[0],Gui.collections_array[1])
			print(left_arrow,"was used in signal")
		right_arrow:
			print(right_arrow,"was used in signal")
			move_match(self,Gui.collections_array[1],Gui.collections_array[2],Gui.collections_array[0])
		down_arrow:
			print(down_arrow,"was used in signal")
		_:
			print("match do nothing as in brokey")
	print("PARENT OF NODE",self.get_parent())

func move_match(first_function:Node,second_first:Node,second_second:Node,second_third:Node) -> void:
	match self.get_parent():
		Gui.collection_1:
			move_node(first_function,second_first)
		Gui.collection_2:
			move_node(first_function,second_second)
		Gui.collection_3:
			move_node(first_function,second_third)

func move_node(node: Node, new_parent:Node) -> void:
	node.get_parent().remove_child(node)
	new_parent.add_child(node)