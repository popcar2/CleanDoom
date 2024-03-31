extends Panel

@onready var profiles_container: PanelContainer = %ProfilesContainer
@onready var profiles_vbox: VBoxContainer = profiles_container.get_node("VBoxContainer")

var profile_panel: PackedScene = preload("res://Scenes/ProfilePanel/profile_panel.tscn")

var is_mouse_over: bool

func _ready():
	# Read profiles on startup
	await get_tree().process_frame
	for file: String in DirAccess.get_files_at("user://Profiles/"):
		var new_panel: ProfilePanel = profile_panel.instantiate()
		new_panel.get_node("%ProfileName").text = "[center]%s" % file.trim_suffix(".json")
		profiles_vbox.add_child(new_panel)
	
	if profiles_container.get_node("VBoxContainer").get_child_count() == 0:
		%SelectedProfileText.text = "Default"
		add_profile_panel("Default")
	
	profiles_vbox.add_child(HSeparator.new())
	profiles_vbox.add_child(load("res://Scenes/NewProfile/new_profile_button.tscn").instantiate())

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		if is_mouse_over:
			toggle_profiles_container()
		elif profiles_container.visible:
			hide_profiles_container()

func _on_mouse_entered() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "self_modulate", Color("f3201e"), 0.2)
	is_mouse_over = true

func _on_mouse_exited() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "self_modulate", Color("b81111"), 0.2)
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

func hide_profiles_container():
	profiles_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(profiles_container, "modulate:a", 0, 0.2)
	await tween.tween_property(profiles_container, "position:y", 20.0, 0.2).finished
	if profiles_container.visible:
		profiles_container.visible = false

func add_profile_panel(profile_name: String):
	var new_panel: ProfilePanel = profile_panel.instantiate()
	new_panel.get_node("%ProfileName").text = "[center]%s" % profile_name
	profiles_vbox.add_child(new_panel)
	await get_tree().process_frame
	# Moves this above new profile button and separator
	profiles_vbox.move_child(new_panel, -3) # TODO make this less hacky lol
