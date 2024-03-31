extends Window

func show_window():
	show()
	%ProfileName.grab_focus()

func _on_close_requested():
	hide()

func _on_cancel_pressed():
	hide()

func _on_continue_pressed():
	$"/root/MainScene".create_profile(%ProfileName.text)
	hide()
