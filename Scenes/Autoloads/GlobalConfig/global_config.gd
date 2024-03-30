extends Node

@onready var main_scene: MainScene = $"/root/MainScene"

var default_exe: String
var default_iwad: String

func _ready() -> void:
	DisplayServer.window_set_min_size(Vector2i(512, 300))
	
	var refresh_rate: float = DisplayServer.screen_get_refresh_rate()
	if refresh_rate < 0:
		Engine.max_fps = 60
	else:
		Engine.max_fps = round(refresh_rate)
	
	if !DirAccess.dir_exists_absolute("user://Profiles/"):
		DirAccess.make_dir_absolute("user://Profiles/")
		main_scene.visible = false
		main_scene.add_sibling.call_deferred(load("res://Scenes/Intro/Intro.tscn").instantiate())
	else:
		main_scene.load_profile()
