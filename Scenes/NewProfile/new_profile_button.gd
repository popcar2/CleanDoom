extends Panel

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		$NewProfileWindow.show_window()

func _on_mouse_entered() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "self_modulate", GlobalConfig.color_red_selected, 0.15)

func _on_mouse_exited() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "self_modulate", GlobalConfig.color_red, 0.15)
