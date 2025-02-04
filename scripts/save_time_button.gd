extends interact_button

func _on_pressed() -> void:
	var minutes:LineEdit = get_parent().find_child("MinutesInput")
	var seconds:LineEdit = get_parent().find_child("SecondsInput")
	if minutes.saved_text == "" or seconds.saved_text == "":
		print("no value")
		return
	var minutes_value:int = str_to_var(minutes.saved_text) * 60
	var seconds_value:int = str_to_var(seconds.saved_text)
	var time:int = minutes_value + seconds_value
	SaveSystem.save_cooldown = time
	SaveSystem.save_variables(true)
	SignalManager.emit_signal("change_timer_cooldown")