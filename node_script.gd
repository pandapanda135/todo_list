extends Control

signal node_made

@onready var arrow_handler:Control = $ArrowHandler

@onready var up_arrow: Button = $ArrowHandler/UpArrow
@onready var right_arrow: Button = $ArrowHandler/RightArrow
@onready var down_arrow: Button = $ArrowHandler/DownArrow
@onready var left_arrow: Button = $ArrowHandler/LeftArrow

@onready var json_file:String
@export var current_position:int

@onready var root:Window = get_tree().get_root()
var timer_running:bool = false
@export var index_saving_timer:int = 300
#declare the collection is will be in within the save file modfiy the save file code
#to support this and also the function that adds the nodes to the scenes this can be done
#by moving the code that spawn the code into the load_node function so it is being loaded
#and moved which should be easier

#TODO: add either a system to update a file or write over an exisiting file so new node position can be saved and also edit a note and also for index saving later
#current idea is write over file by stealing code from load note and save note this can be done with 4 (or however many option arguments are needed)
#and the new value will be passed through that there could also be another argument that can be an int that will decide the line that will be changed with a match statment
func _ready() -> void:
	var save_edit_button = get_node("ModalController/HFlowContainer/Control/SaveButton")
	save_edit_button.get_save_file.connect(_get_save_file)

	var _up_arrow_signal:bool = up_arrow.pressed.connect(check_node_position.bind(up_arrow))
	var _left_arrow_singal:bool = left_arrow.pressed.connect(check_node_position.bind(left_arrow))
	var _right_arrow_signal:bool = right_arrow.pressed.connect(check_node_position.bind(right_arrow))
	var _down_arrow_signal:bool = down_arrow.pressed.connect(check_node_position.bind(down_arrow))

	node_made.connect(_on_node_made)
	node_made.emit.call_deferred()
	SignalManager.connect("index_saving", _save_index)
	first_arrow_visibility_check()

func _get_save_file() -> void: # this is used for edit button
	SaveSystem.selected_json_file = json_file

func _save_index(save_time,is_closing) -> void: # modify this is it adds a 5 min timer that will have a signal that when over it will run this line
	print("SAVE_INDEX RUN")

	if is_closing == true:
		SaveSystem.change_note(json_file,3,"",self.get_index())
		return

	if timer_running == false:
		timer_running  = true
		await get_tree().create_timer(save_time).timeout
		print("THIS IS INDEx",self.get_index())
		SaveSystem.change_note(json_file,3,"",self.get_index())
		timer_running = false
	else:
		print("timer already exists")


func check_node_position(clicked_node) -> void:
	check_arrow_visibility()
	print("running move_node with",clicked_node)
	match clicked_node:
		up_arrow:
			move_node_vertical(false)
			print(up_arrow,"was used in signal")
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

#args are new node that the move to depending on what the parent of self is
func move_match(second_first:Node,second_second:Node,second_third:Node) -> void:
	match self.get_parent():
		Gui.collection_1:# if left node it will go to third collection if right will go to second collection
			move_node_horizontal(second_first)
		Gui.collection_2:
			move_node_horizontal(second_second)
		Gui.collection_3:
			move_node_horizontal(second_third)

func _on_node_made() -> void:
	var spawn_tree:Array[Node] = get_parent().get_children() #stops down arrow being disabled when new node is made
	if len(spawn_tree) > 1:
		print("FIRST IF DONE WOOOOOOOO")
		spawn_tree[len(spawn_tree) - 2].down_arrow.disabled = false
	print("SIGNAL")
	first_arrow_visibility_check()

#CONSIDER:maybe add something that makes it so it keeps it current index in the collection on move? DONE KINDA
func move_node_horizontal(new_parent:Node) -> void: #reparent node
	var current_index:int = self.get_index()
	var new_children:int = new_parent.get_child_count()
	var last_parent:Node = self.get_parent()

	if current_index > new_children:
		self.reparent(new_parent)
		new_parent.move_child(self,new_children + 1)
	elif current_index <= new_children:
		self.reparent(new_parent)
		new_parent.move_child(self,current_index)
	check_arrow_visibility(last_parent)

	match new_parent: #change which container is selected in save file
		Gui.collection_1:
			SaveSystem.change_note(json_file,2,"",0)
		Gui.collection_2:
			SaveSystem.change_note(json_file,2,"",1)
		Gui.collection_3:
			SaveSystem.change_note(json_file,2,"",2)
	SignalManager.emit_signal("index_saving",index_saving_timer,false)

func move_node_vertical(Down:bool) -> void:
	var parent:Node = get_parent()
	var current_index:int = self.get_index()

	if Down == true:
		parent.move_child(self,current_index + 1)
	else:
		# print("before move_child",get_parent().get_children())
		parent.move_child(self,current_index - 1)
		# print("after move_child",get_parent().get_children())
	check_arrow_visibility()

	SignalManager.emit_signal("index_saving",index_saving_timer,false)

#look if there is a node above or belo current node if so then keep button enabled else set disabled
#this breaks if nodes are invisible as they are still in the tree however they dont display so only the appropriate nodes get disabled
func check_arrow_visibility(last_parent:Node = null) -> void:
	var child_nodes:Array[Node] = get_parent().get_children()
	var node_index:int = child_nodes.find(self)
	var max_index:int = self.get_parent().get_child_count()
	# print("nfgs",child_nodes)
	# print("FGIUHDGFSHIU",child_nodes[- 1])

	print("last_parent",last_parent)
	if last_parent != null:
		disable_horizontal(last_parent)
	else:
		print("last_parent == null")

	first_arrow_visibility_check()
	#fixes issues to do with when the top note is moved down and the new top note is not correctly updated to show that
	#double check because I am a horrible programmer
	if child_nodes[0].up_arrow.disabled == true and node_index > 0:
		# print("adfgoihgiofdg",child_nodes[1])
		child_nodes[1].up_arrow.disabled = false
	elif down_arrow.disabled == true and node_index < max_index:
		down_arrow.disabled = false
		pass
	else:
		child_nodes[1].up_arrow.disabled = false
		child_nodes[0].up_arrow.disabled = true
		print("none on end if")

	#seperate if because issues I cant be bothered to fix
	if self == child_nodes[max_index - 2] and child_nodes[max_index - 1].down_arrow.disabled != true:
		print("line 127 down arrow disabled")
		child_nodes[max_index - 1].down_arrow.disabled = true
	else:
		pass

	#down check so one from down when press down doesnt sets down_arrow back to false
	if node_index + 1 < child_nodes.size():
		pass #i dont think there are any issues relating to this so it pass
	else:
		print("down disabled")
		child_nodes[max_index - 2].down_arrow.disabled = false
		print(down_arrow," disabled line 138")

func first_arrow_visibility_check() -> void:
	var child_nodes:Array[Node] = get_parent().get_children()

	if self in child_nodes:
		var node_index:int = child_nodes.find(self)
		var node_index_1:int = node_index + 1
		# print("OIGJSODGIO",max_index)
		# print("IHDFSKJIOh",child_nodes[max_index - 2])
		#up check
		if child_nodes[node_index - 1] != child_nodes[-1]:
			print("up not disabled")
			up_arrow.disabled = false
		else:
			print("up disabled")
			up_arrow.disabled = true #good
			# print(child_nodes[max_index - 2])
			# child_nodes[0].up_arrow.disabled = false

		#down check THIS DOESNT WORK WHEN NEW NODE IS MADE DEAR GOD WHY
		print(node_index + 1," this is the diff ",child_nodes.size())
		if node_index_1 < child_nodes.size():
			print("down not disabled")
			down_arrow.disabled = false
		else:
			print("down disabled")
			down_arrow.disabled = true #bad
			print(down_arrow," disabled line 166")

func disable_horizontal(last_parent) -> void:
	var last_parent_children:Array[Node] = last_parent.get_children()
	var last_parent_child_count:int = last_parent.get_child_count()

	if last_parent_child_count == 0:
		return

	if last_parent_children[0].up_arrow.disabled == false:
		print("FIRST IF DISABLE_HORIZONTAL")
		last_parent_children[0].up_arrow.disabled = true
	elif last_parent_children[last_parent_child_count - 1].down_arrow.disabled == false:
		print("SECOND IF DISABLE_HORIZONTAL")
		last_parent_children[last_parent_child_count - 1].down_arrow.disabled = true
	else:
		print("NONE DISABLED")

func save() -> int:
	return self.get_index()

#handles saving index when closed
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SignalManager.emit_signal("index_saving",0,true)
		get_tree().quit()