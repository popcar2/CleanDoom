extends Button

func _ready() -> void:
	%ModsVBoxContainer.child_entered_tree.connect(mods_box_updated)
	%ModsVBoxContainer.child_exiting_tree.connect(mods_box_updated)
	mods_box_updated(null)

func _on_pressed() -> void:
	if %ModsVBoxContainer.get_child_count() == 0:
		return
	
	var selected_panel = %ModsVBoxContainer.get_child(0).selected_panel
	if selected_panel == null:
		return
	
	selected_panel.queue_free()
	
	await get_tree().process_frame
	$"/root/MainScene".save_profile()

func mods_box_updated(_mod_panel: ModPanel):
	await get_tree().process_frame
	if %ModsVBoxContainer.get_child_count() == 0:
		disabled = true
		%NoModsTexts.visible = true
	else:
		disabled = false
		%NoModsTexts.visible = false
