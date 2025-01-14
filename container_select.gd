extends OptionButton

var saved_option:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.item_selected.connect(_on_item_selected)

func _on_item_selected(index) -> void:
	saved_option = index
	print("THIS IS SAVED OPTION",saved_option)
	save()

func save() -> int:
	return saved_option