extends Control

@onready var arrow_handler:Control = $ArrowHandler

@onready var up_arrow: Button = $ArrowHandler/UpArrow
@onready var right_arrow: Button = $ArrowHandler/RightArrow
@onready var down_arrow: Button = $ArrowHandler/DownArrow
@onready var left_arrow: Button = $ArrowHandler/LeftArrow

@export var json_file:String = ""
@export var current_position:int

#declare the collection is will be in within the save file modfiy the save file code
#to support this and also the function that adds the nodes to the scenes this can be done
#by moving the code that spawn the code into the load_node function so it is being loaded
#and moved which should be easier

#TODO: could fix the issue of inaccurate arrow viability with a signal sent everytime a node spawns
func _ready():
	var _up_arrow_signal:bool = up_arrow.pressed.connect(check_node_position.bind(up_arrow))
	var _left_arrow_singal:bool = left_arrow.pressed.connect(check_node_position.bind(left_arrow))
	var _right_arrow_signal:bool = right_arrow.pressed.connect(check_node_position.bind(right_arrow))
	var _down_arrow_signal:bool = down_arrow.pressed.connect(check_node_position.bind(down_arrow))
	first_arrow_visibility_check()

func check_node_position(clicked_node) -> void:
	check_arrow_visibility()
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

#CONSIDER:maybe add something that makes it so it keeps it current index in the collection on move? DONE KINDA
func move_node_horizontal(new_parent:Node) -> void:
	var current_index = self.get_index()
	var new_children = new_parent.get_child_count()

	if current_index > new_children:
		self.reparent(new_parent)
		new_parent.move_child(self,new_children + 1)
	elif current_index <= new_children:
		self.reparent(new_parent)
		new_parent.move_child(self,current_index)
	check_arrow_visibility()

func move_node_vertical(Down:bool) -> void:
	var parent = get_parent()
	var current_index:int = self.get_index()

	if Down == true:
		parent.move_child(self,current_index + 1)
	else:
		# print("before move_child",get_parent().get_children())
		parent.move_child(self,current_index - 1)
		# print("after move_child",get_parent().get_children())
	check_arrow_visibility()

#TODO: when the node is made there is nothing beneath them so the down arrow will always be disabled until it moves
#look if there is a node above or below current node if so then keep button enabled else set disabled
func check_arrow_visibility() -> void:
	var child_nodes:Array = get_parent().get_children()
	var node_index:int = child_nodes.find(self)
	var max_index:int = self.get_parent().get_child_count()
	# print("nfgs",child_nodes)
	# print("FGIUHDGFSHIU",child_nodes[- 1])

	first_arrow_visibility_check()
	#fixes issues to do with when the top note is moved down and the new top note is not correctly updated to show that
	#double check because I am a horrible programmer
	if child_nodes[0].up_arrow.disabled == true and node_index >= 0:
		# print("adfgoihgiofdg",child_nodes[1])
		child_nodes[1].up_arrow.disabled = false
	elif down_arrow.disabled == true and node_index < max_index:
		# down_arrow.disabled = false
		pass
	else:
		print("none on end if")

	#seperate if because issues I cant be bothered to fix
	if self == child_nodes[max_index - 2] and child_nodes[max_index - 1].down_arrow.disabled != true:
		child_nodes[max_index - 1].down_arrow.disabled = true
	else:
		pass

func first_arrow_visibility_check() -> void:
	var child_nodes:Array = get_parent().get_children()

	if self in child_nodes:
		var node_index:int = child_nodes.find(self)
		var node_index_1:int = node_index + 1
		var max_index:int = self.get_parent().get_child_count()
		# print("OIGJSODGIO",max_index)
		# print("IHDFSKJIOh",child_nodes[max_index - 2])
		#up check
		if child_nodes[node_index - 1] != child_nodes[-1]:
			print("up not disabled")
			up_arrow.disabled = false
		else:
			print("up disabled")
			up_arrow.disabled = true
			# print(child_nodes[max_index - 2])
			# child_nodes[0].up_arrow.disabled = false

		#down check
		print(node_index + 1," this is the diff ",child_nodes.size())
		if node_index_1 < child_nodes.size():
			print("down not disabled")
			down_arrow.disabled = false
		else:
			print("down disabled")
			down_arrow.disabled = true
			# print("asdo ",max_index)
			# print(child_nodes[max_index - 2])
			# print(child_nodes)
			# child_nodes[max_index - 2].down_arrow.disabled = false
			print("I am after false",child_nodes[max_index - 2])
			# down_arrow.disabled = true