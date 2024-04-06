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
	var text: String = %ProfileName.text
	if text.is_empty():
		return
	
	# Strip illegal characters
	for illegal_char: String in "!@#$%^&*/?\\;:()+=".split(''):
		text = text.replace(illegal_char, '')
	
	$"/root/MainScene".create_profile(text)
	_on_close_requested()


func _on_profile_name_text_submitted(_new_text):
	_on_continue_pressed()
