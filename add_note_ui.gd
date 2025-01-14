extends Button

@onready var modal:Control = $"../ModalController"

func _ready() -> void:
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if modal.visible == true:
		modal.visible = false
	else:
		modal.visible = true
