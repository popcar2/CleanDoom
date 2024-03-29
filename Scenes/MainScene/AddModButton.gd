extends Button

var mod_panel_scene: PackedScene = preload("res://Scenes/ModPanel/mod_panel.tscn")

func _on_pressed() -> void:
	$FileDialog.visible = true

func _on_files_selected(paths: PackedStringArray, flash: bool = true) -> void:
	for path: String in paths:
		if is_duplicate_file(path):
			continue
		
		var mod_panel: ModPanel = mod_panel_scene.instantiate()
		mod_panel.get_node("%ModPathText").text = path
		
		var file_name: String = path.get_file().split(".")[0]
		
		mod_panel.get_node("%ModTitleText").text = file_name
		
		%ModsVBoxContainer.add_child(mod_panel)
		
		if flash:
			mod_panel.flash_panel()

func is_duplicate_file(path: String) -> bool:
	for panel: ModPanel in %ModsVBoxContainer.get_children():
		if panel.get_node("%ModPathText").text == path:
			panel.flash_panel()
			return true
	
	return false
