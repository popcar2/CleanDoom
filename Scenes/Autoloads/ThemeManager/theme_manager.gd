extends Node

## This has to be the dumbest and most brilliant idea I've ever had.
## Rather than manage themes, I just have global color constants and
## self_modulate everything in specific groups so I can quickly change
## color palettes. WHAT COULD GO WRONG!?!??!!

@export var background_color: Color = Color("232323"):
	set(val):
		background_color = val
		if !is_inside_tree(): return
		RenderingServer.set_default_clear_color(background_color)

@export var panel_light: Color = Color("ab020a"):
	set(val):
		panel_light = val
		if !is_inside_tree(): return
		for control: Control in get_tree().get_nodes_in_group("color_panel_light"):
			control.self_modulate = panel_light
		update_all_button_colors()

@export var panel_default: Color = Color("9d0208"):
	set(val):
		panel_default = val
		if !is_inside_tree(): return
		for control: Control in get_tree().get_nodes_in_group("color_panel_default"):
			control.self_modulate = panel_default
		update_all_button_colors()

@export var panel_dark: Color = Color("370600"):
	set(val):
		panel_dark = val
		if !is_inside_tree(): return
		for control: Control in get_tree().get_nodes_in_group("color_panel_dark"):
			control.self_modulate = panel_dark
		update_all_button_colors()

@export var panel_highlight: Color = Color("d00000"):
	set(val):
		panel_highlight = val
		if !is_inside_tree(): return
		for control: Control in get_tree().get_nodes_in_group("color_panel_highlight"):
			control.self_modulate = panel_highlight
		update_all_button_colors()

@export var panel_selected: Color = Color.DARK_CYAN:
	set(val):
		panel_selected = val
		if !is_inside_tree(): return
		for control: Control in get_tree().get_nodes_in_group("color_panel_selected"):
			control.self_modulate = panel_selected

@export var panel_flash: Color = Color("faa307")

func _enter_tree():
	RenderingServer.set_default_clear_color(background_color)
	get_tree().node_added.connect(set_color)

func set_color(node: Node):
	if !(node is Control):
		return
	
	if node.is_in_group("color_panel_default"):
		node.self_modulate = panel_default
	elif node.is_in_group("color_panel_dark"):
		node.self_modulate = panel_dark
	elif node.is_in_group("color_panel_light"):
		node.self_modulate = panel_light
	elif node.is_in_group("color_button_regular"):
		set_button_color(node, panel_default, panel_highlight, panel_default.darkened(0.05), panel_dark)
	elif node.is_in_group("color_button_dark"):
		set_button_color(node, panel_dark, panel_highlight, panel_default.darkened(0.05), panel_dark)
	elif node.is_in_group("color_button_toggle"):
		set_button_color(node, panel_default.darkened(0.25), panel_highlight, panel_light, panel_dark)

## As a separate function because it's called each time a color is set
func update_all_button_colors():
	for button: Button in get_tree().get_nodes_in_group("color_button_regular"):
		set_button_color(button, panel_default, panel_highlight, panel_default.darkened(0.05), panel_dark)
	for button: Button in get_tree().get_nodes_in_group("color_button_dark"):
		set_button_color(button, panel_dark, panel_highlight, panel_default.darkened(0.05), panel_dark)
	for button: Button in get_tree().get_nodes_in_group("color_button_toggle"):
		set_button_color(button, panel_default.darkened(0.25), panel_highlight, panel_light, panel_dark)

func set_button_color(button: Button, normal_color: Color, hover_color: Color, pressed_color: Color, disabled_color: Color):
	button["theme_override_styles/normal"]["bg_color"] = normal_color
	button["theme_override_styles/hover"]["bg_color"] = hover_color
	if button["theme_override_styles/pressed"] != null:
		button["theme_override_styles/pressed"]["bg_color"] = pressed_color
	if button["theme_override_styles/disabled"] != null:
		button["theme_override_styles/disabled"]["bg_color"] = disabled_color
