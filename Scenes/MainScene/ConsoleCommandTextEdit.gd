extends TextEdit

@onready var parent_panel: Panel = get_parent()

var is_mouse_inside: bool

func _ready():
	# Just removing some useless things from the context menu
	var menu: PopupMenu = get_menu()
	
	menu.remove_item(13)
	menu.remove_item(12)
	menu.remove_item(11)
	menu.remove_item(10)
	menu.remove_item(9)

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


func _on_text_changed():
	if text.ends_with("\n"):
		text = text.trim_suffix("\n")
		$"../../.."._on_continue_pressed()
