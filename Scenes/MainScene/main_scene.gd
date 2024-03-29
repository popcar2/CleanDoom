extends Control

func _ready() -> void:
	if GlobalConfig.default_exe.is_empty():
		visible = false
		add_sibling.call_deferred(load("res://Scenes/Intro/Intro.tscn").instantiate())

func _on_start_button_pressed() -> void:
	start_game()
	%StartButton.text = "Have fun!"
	await get_tree().create_timer(1).timeout
	%StartButton.text = "Start Game"

func start_game() -> void:
	OS.create_process(GlobalConfig.default_exe, ["-file %s" % GlobalConfig.default_iwad])
