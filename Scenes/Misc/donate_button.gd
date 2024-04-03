extends Button

func _on_pressed():
	OS.shell_open("https://www.buymeacoffee.com/popcar2")

func _on_mouse_entered():
	text = "Donate!"

func _on_mouse_exited():
	text = "Donate?"
