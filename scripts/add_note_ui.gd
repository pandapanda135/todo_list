extends interact_button

@onready var modal:Control = $"../ModalController"

func _on_pressed() -> void:
	modal.visible = not modal.visible