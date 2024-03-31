extends Window

func _on_close_requested():
	hide()

func _on_cancel_pressed():
	hide()

func _on_delete_pressed():
	hide()
	$"../../..".delete_profile_panel()

func _on_trash_button_pressed():
	show()
