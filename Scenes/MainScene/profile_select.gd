extends Panel

@onready var profiles_container: PanelContainer = $ProfilesContainer

var profile_panel: PackedScene = preload("res://Scenes/ProfilePanel/profile_panel.tscn")

var is_mouse_over: bool

func _ready():
	# Read profiles on startup
	await get_tree().process_frame
	for file: String in DirAccess.get_files_at("user://Profiles/"):
		var new_panel: ProfilePanel = profile_panel.instantiate()
		new_panel.get_node("%ProfileName").text = "[center]%s" % file.trim_suffix(".json")
		profiles_container.get_node("VBoxContainer").add_child(new_panel)
	
	if profiles_container.get_node("VBoxContainer").get_child_count() == 0:
		%SelectedProfileText.text = "Default"
		var new_panel: ProfilePanel = profile_panel.instantiate()
		new_panel.get_node("%ProfileName").text = "[center]Default"
		profiles_container.get_node("VBoxContainer").add_child(new_panel)

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
	
	profiles_container.visible = true
	tween.tween_property(profiles_container, "modulate:a", 1, 0.4)
	tween.tween_property(profiles_container, "position:y", 57.0, 0.4).from(20.0)

func hide_profiles_container():
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(profiles_container, "modulate:a", 0, 0.2)
	await tween.tween_property(profiles_container, "position:y", 20.0, 0.2).finished
	if profiles_container.visible:
		profiles_container.visible = false
