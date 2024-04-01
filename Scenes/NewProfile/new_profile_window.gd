extends Window

func show_window():
	show()
	%ProfileName.grab_focus()

func _on_close_requested():
	hide()
	%ProfileName.text = ""

func _on_cancel_pressed():
	_on_close_requested()

func _on_continue_pressed():
	$"/root/MainScene".create_profile(%ProfileName.text)
	_on_close_requested()
