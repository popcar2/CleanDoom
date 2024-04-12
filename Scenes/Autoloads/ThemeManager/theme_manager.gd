extends Node

## This has to be the dumbest and most brilliant idea I've ever had.
## Rather than manage themes, I just have global color constants and
## self_modulate everything in specific groups so I can quickly change
## color palettes. WHAT COULD GO WRONG!?!??!!

## Forces the game to use these colors in the inspector rather than read the save file
@export var force_these_colors: bool

@export var background_color: Color = Color("232323"):
	set(val):
		background_color = val
		#if !is_inside_tree(): return
		RenderingServer.set_default_clear_color(background_color)

@export var panel_light: Color = Color("ab020a"):
	set(val):
		panel_light = val
		if !is_inside_tree(): return
		set_group_color("color_panel_light", panel_light)
		update_all_button_colors()

@export var panel_default: Color = Color("9d0208"):
	set(val):
		panel_default = val
		if !is_inside_tree(): return
		set_group_color("color_panel_default", panel_default)
		update_all_button_colors()

@export var panel_dark: Color = Color("370600"):
	set(val):
		panel_dark = val
		if !is_inside_tree(): return
		set_group_color("color_panel_dark", panel_dark)
		update_all_button_colors()

@export var panel_highlight: Color = Color("d00000"):
	set(val):
		panel_highlight = val
		if !is_inside_tree(): return
		set_group_color("color_panel_highlight", panel_highlight)
		update_all_button_colors()

@export var panel_selected: Color = Color.DARK_CYAN:
	set(val):
		panel_selected = val
		if !is_inside_tree(): return
		set_group_color("color_panel_selected", panel_selected)

@export var panel_flash: Color = Color("faa307")

func _enter_tree():
	RenderingServer.set_default_clear_color(background_color)
	get_tree().node_added.connect(set_color)
	if !force_these_colors:
		load_theme()

func save_theme():
	var data: Dictionary = {
		"background_color": background_color.to_html(false),
		"panel_light": panel_light.to_html(false),
		"panel_default": panel_default.to_html(false),
		"panel_dark": panel_dark.to_html(false),
		"panel_highlight": panel_highlight.to_html(false),
		"panel_selected": panel_selected.to_html(false),
		"panel_flash": panel_flash.to_html(false)
	}
	
	var save_string: String = JSON.stringify(data)
	var file_access := FileAccess.open("user://theme.json", FileAccess.WRITE)
	if not file_access:
		printerr("Failed to save file: ", FileAccess.get_open_error())
		return
	
	file_access.store_line(save_string)
	file_access.close()

func load_theme():
	if not FileAccess.file_exists("user://theme.json"):
		save_theme()
		return
	
	var file_access: FileAccess = FileAccess.open("user://theme.json", FileAccess.READ)
	var save_string: String = file_access.get_line()
	file_access.close()
	
	var json: JSON = JSON.new()
	var err: Error = json.parse(save_string)
	if err:
		printerr("JSON Parse Error: ", json.get_error_message(), " in ", save_string, " at line ", json.get_error_line())
		return
	
	var theme_data: Dictionary = json.data
	
	background_color = Color(theme_data.background_color)
	panel_light = Color(theme_data.panel_light)
	panel_default = Color(theme_data.panel_default)
	panel_dark = Color(theme_data.panel_dark)
	panel_highlight = Color(theme_data.panel_highlight)
	panel_selected = Color(theme_data.panel_selected)
	panel_flash = Color(theme_data.panel_flash)

func set_theme(theme_name: String):
	if theme_name == "Doom":
		panel_light = Color("ab020a")
		panel_default = Color("9d0208")
		panel_dark = Color("370600")
		panel_highlight = Color("d00000")
		panel_selected = Color("008b8b")
		panel_flash = Color("faa307")
	elif theme_name == "Cyan":
		panel_light = Color("008080")
		panel_default = Color("006666")
		panel_dark = Color("003333")
		panel_highlight = Color("008c8c")
		panel_selected = Color("0059b3")
		panel_flash = Color("00e6ac")
	
	save_theme()

func set_group_color(group_name: String, color: Color):
	for control: Control in get_tree().get_nodes_in_group(group_name):
		control.self_modulate = color

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
