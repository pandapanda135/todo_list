extends interact_button

@onready var modal_controller = $"../ModalController"

func _on_pressed() -> void:
	modal_controller.visible = not modal_controller.visible