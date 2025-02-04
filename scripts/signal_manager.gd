extends Node

signal index_saving(timer_time:float,is_closing:bool)
signal change_timer_cooldown


#handles quit notification
var already_sent_close:bool = false
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST and already_sent_close == false:
		already_sent_close = true
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
