extends Panel

@onready var profiles_container: PanelContainer = %ProfilesContainer
@onready var profiles_vbox: VBoxContainer = profiles_container.get_node("VBoxContainer")
@onready var dropdown_icon: TextureRect = $TextureRect

var profile_panel_scene: PackedScene = preload("res://Scenes/ProfilePanel/profile_panel.tscn")

var is_mouse_over: bool

func _ready():
	# Read profiles on startup
	await get_tree().process_frame
	for file: String in DirAccess.get_files_at("user://Profiles/"):
		add_profile_panel(file.trim_suffix(".json"))
	
	if profiles_container.get_node("VBoxContainer").get_child_count() == 0:
		%SelectedProfileText.text = "[center]Default"
		add_profile_panel("Default")
	
	profiles_vbox.add_child(load("res://Scenes/NewProfile/new_profile_button.tscn").instantiate())

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		if is_mouse_over:
			toggle_profiles_container()
		elif profiles_container.visible:
			hide_profiles_container()

func _on_mouse_entered() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "self_modulate", ThemeManager.panel_highlight, 0.2)
	is_mouse_over = true

func _on_mouse_exited() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "self_modulate", ThemeManager.panel_default, 0.2)
	is_mouse_over = false

func toggle_profiles_container():
	if profiles_container.visible:
		hide_profiles_container()
	else:
		show_profiles_container()

func show_profiles_container():
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	await get_tree().process_frame
	profiles_container.visible = true
	tween.tween_property(profiles_container, "modulate:a", 1, 0.4)
	tween.tween_property(profiles_container, "position:y", 57.0, 0.4).from(20.0)
	tween.tween_property(dropdown_icon, "scale:y", -1, 0.2)

func hide_profiles_container():
	profiles_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(profiles_container, "modulate:a", 0, 0.2)
	tween.tween_property(dropdown_icon, "scale:y", 1, 0.2)
	await tween.tween_property(profiles_container, "position:y", 20.0, 0.2).finished
	if profiles_container.visible:
		profiles_container.visible = false

func add_profile_panel(profile_name: String):
	var new_panel: ProfilePanel = profile_panel_scene.instantiate()
	new_panel.get_node("%ProfileName").text = "[center]%s" % profile_name
	if profile_name == "Default":
		new_panel.get_node("%TrashButton").disabled = true
	profiles_vbox.add_child(new_panel)
	await get_tree().process_frame
	# Moves this above new profile button and separator
	profiles_vbox.move_child(new_panel, -2) # TODO make this less hacky lol
	
	if profiles_vbox.get_child_count() > 10:
		reduce_profile_list_size()

## Reduces the size of profiles when there are too many to stop it from going off-screen
## In the future I should switch to a scroll container
func reduce_profile_list_size():
	profiles_vbox["theme_override_constants/separation"] = 2
	for profile_panel: Control in profiles_vbox.get_children():
		if profile_panel is ProfilePanel:
			profile_panel.custom_minimum_size.y = 25
			profile_panel.get_node("%ProfileName")["theme_override_font_sizes/normal_font_size"] = 18

func restore_profile_list_size():
	profiles_vbox["theme_override_constants/separation"] = 4
	for profile_panel: Control in profiles_vbox.get_children():
		if profile_panel is ProfilePanel:
			profile_panel.custom_minimum_size.y = 40
			profile_panel.get_node("%ProfileName")["theme_override_font_sizes/normal_font_size"] = 20
