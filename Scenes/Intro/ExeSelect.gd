extends Panel

@export var windows_file_filter: String

@onready var file_dialog: FileDialog = $FileDialog

var is_mouse_inside: bool

func _ready() -> void:
	if OS.has_feature("windows"):
		file_dialog.add_filter(windows_file_filter)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and is_mouse_inside:
		if event.button_index == 1 and event.is_pressed():
			file_dialog.visible = true

func _on_mouse_entered() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "self_modulate", ThemeManager.panel_highlight, 0.2)
	is_mouse_inside = true

func _on_mouse_exited() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "self_modulate", ThemeManager.panel_default, 0.2)
	is_mouse_inside = false

func _on_file_dialog_file_selected(path: String) -> void:
	$RichTextLabel.text = path
