extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._on_pressed)

func _on_pressed() -> void:
	SaveSystem.save_note()
