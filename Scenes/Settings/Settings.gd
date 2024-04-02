extends Control

func _ready():
	await get_tree().process_frame
	
	var config: ConfigFile = ConfigFile.new()
	
	var err: Error = config.load("user://settings.cfg")
	
	if err != OK:
		save_config()
		return
	
	load_config()

func save_config():
	var config: ConfigFile = ConfigFile.new()
	
	config.set_value("Settings", "close_after_start", %CloseAfterStartButton.button_pressed)
	
	var err: Error = config.save("user://settings.cfg")
	if err != OK:
		printerr("Failed to save config file: ", err)

func load_config():
	var config: ConfigFile = ConfigFile.new()
	
	var err: Error = config.load("user://settings.cfg")
	
	if err != OK:
		printerr("Failed to load config file: ", err)
		return
	
	_on_close_after_start_button_toggled(config.get_value("Settings", "close_after_start"))

func _on_back_button_pressed():
	if modulate.a < 1:
		return
	
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await tween.tween_property(self, "modulate:a", 0, 0.3).finished
	visible = false


func _on_close_after_start_button_toggled(toggled_on: bool):
	if toggled_on:
		GlobalConfig.close_after_starting = true
		%CloseAfterStartButton.button_pressed = true
		%CloseAfterStartButton.text = "ON"
	else:
		GlobalConfig.close_after_starting = false
		%CloseAfterStartButton.button_pressed = false
		%CloseAfterStartButton.text = "OFF"
	
	save_config()
