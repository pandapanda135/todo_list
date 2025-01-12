extends Control

@onready var arrow_handler:Control = $ArrowHandler

@onready var up_arrow: Button = $ArrowHandler/UpArrow
@onready var right_arrow: Button = $ArrowHandler/RightArrow
@onready var down_arrow: Button = $ArrowHandler/DownArrow
@onready var left_arrow: Button = $ArrowHandler/LeftArrow

@export var json_file:String = ""

func _ready():
	var _up_arrow_signal:int = up_arrow.pressed.connect(check_node_position.bind(up_arrow))
	var _left_arrow_singal:int = left_arrow.pressed.connect(check_node_position.bind(left_arrow))
	var _right_arrow_signal:int = right_arrow.pressed.connect(check_node_position.bind(right_arrow))
	var _down_arrow_signal:int = down_arrow.pressed.connect(check_node_position.bind(down_arrow))
	check_arrow_viablility()

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
			move_node_vertical(false)
		left_arrow:
			move_match(Gui.collections_array[2],Gui.collections_array[0],Gui.collections_array[1])
			print(left_arrow,"was used in signal")
		right_arrow:
			print(right_arrow,"was used in signal")
			move_match(Gui.collections_array[1],Gui.collections_array[2],Gui.collections_array[0])
		down_arrow:
			move_node_vertical(true)
			print(down_arrow,"was used in signal")
		_:
			print("match do nothing as in brokey")
	print("PARENT OF NODE",self.get_parent())

func move_match(second_first:Node,second_second:Node,second_third:Node) -> void:
	match self.get_parent():
		Gui.collection_1:
			move_node_horizontal(second_first)
		Gui.collection_2:
			move_node_horizontal(second_second)
		Gui.collection_3:
			move_node_horizontal(second_third)

#CONSIDER:maybe add something that makes it so it keeps it current index in the collection on move?
func move_node_horizontal(new_parent:Node) -> void:
	var current_index = self.get_index()
	var new_children = new_parent.get_child_count()

	if current_index > new_children:
		self.reparent(new_parent)
		new_parent.move_child(self,new_children + 1)
	elif current_index <= new_children:
		self.reparent(new_parent)
		new_parent.move_child(self,current_index)
	check_arrow_viablility()

func move_node_vertical(Down:bool) -> void:
	var parent = get_parent()
	var current_index:int = self.get_index()

	if Down == true:
		parent.move_child(self,current_index + 1)
	else:
		parent.move_child(self,current_index - 1)
	check_arrow_viablility()

#look if there is a node above or below current node if so then keep button enabled else set disabled
func check_arrow_viablility() -> void:
	var child_nodes:Array = get_parent().get_children()
	# print("nfgs",child_nodes)
	# print("FGIUHDGFSHIU",child_nodes[- 1])

	if self in child_nodes:
		var node_index:int = child_nodes.find(self)
		var node_index_1:int = node_index + 1
		# print(child_nodes[node_index - 1])
		if child_nodes[node_index - 1] != child_nodes[-1]:
			print("up not disabled")
			up_arrow.disabled = false
		else:
			print("up disabled")
			up_arrow.disabled = true

		print(node_index + 1," this is the diff ",child_nodes.size())
		if node_index_1 < child_nodes.size():
			print("down not disabled")
			down_arrow.disabled = false
		else:
			print("down disabled")
			down_arrow.disabled = true
