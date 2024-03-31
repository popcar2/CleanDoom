extends TextEdit

@onready var parent_panel: Panel = get_parent()

var is_mouse_inside: bool

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		if is_mouse_inside:
			grab_focus()
		else:
			release_focus()

func _on_focus_entered():
	parent_panel["theme_override_styles/panel"].set_border_width_all(3)

func _on_focus_exited():
	parent_panel["theme_override_styles/panel"].set_border_width_all(0)

func _on_mouse_entered():
	is_mouse_inside = true

func _on_mouse_exited():
	is_mouse_inside = false
