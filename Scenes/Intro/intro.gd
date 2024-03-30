extends Control

func _ready() -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", 0, 1).from(-50.0)
	tween.tween_property(self, "modulate:a", 1, 1).from(0.5)


func _on_exe_file_selected(path: String) -> void:
	GlobalConfig.default_exe = path
	if !GlobalConfig.default_iwad.is_empty():
		%ContinueButton.disabled = false


func _on_iwad_file_selected(path: String) -> void:
	GlobalConfig.default_iwad = path
	if !GlobalConfig.default_exe.is_empty():
		%ContinueButton.disabled = false

func _on_continue_button_pressed() -> void:
	var main_scene: Control = $"/root/MainScene"
	main_scene.visible = true
	
	main_scene.get_node("%IWADSelectText").text = "[center]%s" % GlobalConfig.default_iwad.get_file()
	main_scene.get_node("%ExeSelectText").text = "[center]%s" % GlobalConfig.default_exe.get_file()
	
	var window_size: Vector2 = get_window().size
	
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(main_scene, "position:x", 0, 0.75).from(window_size.x)
	tween.tween_property(self, "position:x", -window_size.x, 0.75)
	
	await tween.tween_property(self, "modulate:a", 0, 0.75).finished
	queue_free()
