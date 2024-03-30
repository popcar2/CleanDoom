extends Control
class_name MainScene

var launching_game: bool

func _on_start_button_pressed() -> void:
	if launching_game:
		return
	
	launching_game = true
	start_game()
	%StartButton.text = "Have fun!"
	await get_tree().create_timer(1).timeout
	%StartButton.text = "Start Game"
	launching_game = false
	#get_tree().quit()

func start_game() -> void:
	var run_flatpak: bool = GlobalConfig.default_exe == "GZDoom (Flatpak)"
	var argument_strings: Array[String] = []
	
	if run_flatpak:
		argument_strings += ["run", "org.zdoom.GZDoom"]
	
	argument_strings += ["-iwad", GlobalConfig.default_iwad]
	
	if %ModsVBoxContainer.get_children().size() > 0:
		argument_strings.append("-file")
		for mod_panel: Panel in %ModsVBoxContainer.get_children():
			if !mod_panel.get_node("%CheckBox").button_pressed:
				continue
			argument_strings.append("%s" % mod_panel.get_node("%ModPathText").text)
	
	if run_flatpak:
		OS.create_process("flatpak", argument_strings)
	else:
		OS.create_process(GlobalConfig.default_exe, argument_strings)
	
	save_profile()

func save_profile() -> void:
	var wad_paths: Array[String] = []
	var wads_enabled: Array[bool] = []
	
	for mod_panel in %ModsVBoxContainer.get_children():
		wad_paths.append(mod_panel.get_node("%ModPathText").text)
		wads_enabled.append(mod_panel.get_node("%CheckBox").button_pressed)
	
	var data: Dictionary = {
		"default_exe": GlobalConfig.default_exe,
		"default_iwad": GlobalConfig.default_iwad,
		"wad_paths": wad_paths,
		"wads_enabled": wads_enabled
	}
	
	var save_string: String = JSON.stringify(data)
	var file_access := FileAccess.open("user://Profiles/Default.json", FileAccess.WRITE)
	if not file_access:
		printerr("Failed to save file: ", FileAccess.get_open_error())
		return
	
	file_access.store_line(save_string)
	file_access.close()

func load_profile(profile_name: String = "Default") -> void:
	var save_path: String = "user://Profiles/%s.json" % profile_name
	if not FileAccess.file_exists(save_path):
		return
	
	var file_access: FileAccess = FileAccess.open(save_path, FileAccess.READ)
	var save_string: String = file_access.get_line()
	file_access.close()
	
	var json: JSON= JSON.new()
	var err: Error = json.parse(save_string)
	if err:
		print("JSON Parse Error: ", json.get_error_message(), " in ", save_string, " at line ", json.get_error_line())
		return
	
	var save_data: Dictionary = json.data
	GlobalConfig.default_exe = save_data.default_exe
	GlobalConfig.default_iwad = save_data.default_iwad
	%IWADSelectText.text = "[center]%s" % save_data.default_iwad.get_file()
	%ExeSelectText.text = "[center]%s" % save_data.default_exe.get_file()
	%AddModButton._on_files_selected(save_data.wad_paths as PackedStringArray, false)
	
	for mod_panel: ModPanel in %ModsVBoxContainer.get_children():
		mod_panel.get_node("%CheckBox").button_pressed = save_data.wads_enabled.pop_front()

func _exit_tree() -> void:
	save_profile()

func _on_iwad_selected(path: String) -> void:
	GlobalConfig.default_iwad = path
	%IWADSelectText.text = "[center]%s" % path.get_file()

func _on_exe_selected(path: String) -> void:
	GlobalConfig.default_exe = path
	%ExeSelectText.text = "[center]%s" % path.get_file()
