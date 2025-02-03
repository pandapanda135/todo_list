extends interact_button

@onready var modal:Control = %ModalController #using unique name here as a test

func _on_pressed() -> void:
	modal.visible = not modal.visible