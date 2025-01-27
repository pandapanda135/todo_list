extends OptionButton

var saved_option:int

func _ready() -> void:
	self.item_selected.connect(_on_item_selected)

func _on_item_selected(index:int) -> void:
	saved_option = index
	print("THIS IS SAVED OPTION",saved_option)
	save()

func save() -> int:
	return saved_option