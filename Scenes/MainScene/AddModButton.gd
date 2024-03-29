extends Button

var mod_panel_scene: PackedScene = preload("res://Scenes/MainScene/mod_panel.tscn")

func _on_pressed() -> void:
	$FileDialog.visible = true

func _on_file_dialog_files_selected(paths: PackedStringArray) -> void:
	for path: String in paths:
		var mod_panel: Panel = mod_panel_scene.instantiate()
		mod_panel.get_node("%ModPathText").text = path
		
		var file_name: String
		if OS.has_feature("windows"):
			file_name = path.split("\\")[-1].split(".")[0]
		else:
			file_name = path.split("/")[-1].split(".")[0]
		
		mod_panel.get_node("%ModTitleText").text = file_name
		
		%ModsVBoxContainer.add_child(mod_panel)
