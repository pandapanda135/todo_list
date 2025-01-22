extends Button

@onready var modal_controller = $"../ModalController"

func _ready() -> void:
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	modal_controller.show()
