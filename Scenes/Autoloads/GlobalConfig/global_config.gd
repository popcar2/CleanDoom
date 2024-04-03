extends Node

@onready var main_scene: MainScene

var color_red: Color = Color("9D0208")
var color_red_selected: Color = Color("D00000")

var default_exe: String
var default_iwad: String

var close_after_starting: bool
var different_save_dirs: bool # Creates and manages new save directories per profile

var gzdoom_flatpak_exists: bool

func _ready() -> void:
	main_scene = $"/root/MainScene"
	if main_scene == null:
		return
	DisplayServer.window_set_min_size(Vector2i(720, 300))
	
	var refresh_rate: float = DisplayServer.screen_get_refresh_rate()
	if refresh_rate < 0:
		Engine.max_fps = 60
	else:
		Engine.max_fps = round(refresh_rate)
	
	if !DirAccess.dir_exists_absolute("user://Profiles/"):
		DirAccess.make_dir_absolute("user://Profiles/")
	
	if FileAccess.file_exists("user://Profiles/Default.json"):
		main_scene.load_profile()
	else:
		main_scene.visible = false
		main_scene.add_sibling.call_deferred(load("res://Scenes/Intro/Intro.tscn").instantiate())
	
	# Check if flatpak GZDoom exists
	if OS.has_feature("linux"):
		gzdoom_flatpak_exists = true
		var output: Array[String] = []
		OS.execute("flatpak", ["list"], output)
		
