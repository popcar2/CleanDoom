extends Panel
class_name ProfilePanel

func _ready():
	%DeleteProfileText.text = "[center]Are you sure you want to delete\n[b]%s?" % %ProfileName.text

func delete_profile_panel():
	queue_free()
	$"/root/MainScene".delete_profile(%ProfileName.text.trim_prefix("[center]"))

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		$"/root/MainScene".switch_profile(%ProfileName.text.trim_prefix("[center]"))

func _on_mouse_entered() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "self_modulate", Color("f3201e"), 0.15)

func _on_mouse_exited() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "self_modulate", Color("b81111"), 0.15)
