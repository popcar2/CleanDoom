extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	if GlobalConfig.gzdoom_flatpak_exists:
		visible = true
	else:
		visible = false
