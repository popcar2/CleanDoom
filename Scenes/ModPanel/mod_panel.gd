extends Panel
class_name ModPanel

static var selected_panel: ModPanel

@onready var double_click_timer: Timer = $DoubleClickTimer

var is_mouse_over: bool

var is_grabbed: bool

func _ready() -> void:
	await get_tree().process_frame
	
	# Check if mod actually exists
	if !FileAccess.file_exists(%ModPathText.text):
		$MissingWarning.visible = true
		%ModTitleText.position.x += 15
		%ModTitleText.size.x -= 15

func flash_panel():
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE)
	
	var current_color: Color = self_modulate
	tween.tween_property(self, "self_modulate", current_color, 0.75).from(ThemeManager.panel_flash)

func _input(event: InputEvent) -> void:
	# Handle dragging and re-ordering of mods
	if is_grabbed and event is InputEventMouseMotion:
		if get_global_mouse_position().y - global_position.y > size.y:
			if get_index() < get_parent().get_child_count():
				get_parent().move_child(self, get_index() + 1)
		elif global_position.y - get_global_mouse_position().y > 0:
			if get_index() > 0:
				get_parent().move_child(self, get_index() - 1)
	
	# Handle being selected and deselected
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			if is_mouse_over:
				is_grabbed = true
				
				if !double_click_timer.is_stopped():
					is_grabbed = false
					$FileDialog.visible = true
					double_click_timer.stop()
				else:
					double_click_timer.start(0.25)
				
				if selected_panel != null and selected_panel != self:
					selected_panel.deselect_panel()
				select_panel()
			else:
				is_grabbed = false
				await get_tree().process_frame
				if selected_panel and selected_panel == self:
					deselect_panel()
		
		elif event.button_index == 1 and event.is_released() and selected_panel == self:
			is_grabbed = false
	
	if Input.is_action_just_pressed("delete"):
		if selected_panel == self:
			queue_free()

func select_panel() -> void:
	self_modulate = ThemeManager.panel_highlight
	selected_panel = self

func deselect_panel() -> void:
	self_modulate = ThemeManager.panel_light
	selected_panel = null

func _on_mouse_entered() -> void:
	is_mouse_over = true
	if self != selected_panel:
		self_modulate = self_modulate.lightened(0.20)

func _on_mouse_exited() -> void:
	is_mouse_over = false
	if self != selected_panel:
		self_modulate = ThemeManager.panel_light

func _on_file_dialog_file_selected(path: String) -> void:
	# Validate it doesn't already exist
	for panel: ModPanel in $"/root/MainScene".get_node("%ModsVBoxContainer").get_children():
		if panel.get_node("%ModPathText").text == path:
			panel.flash_panel()
			return
	
	%ModPathText.text = path
	%ModTitleText.text = path.get_file().split(".")[0]
	
	if %MissingWarning.visible:
		$MissingWarning.visible = false
		%ModTitleText.position.x -= 15
		%ModTitleText.size.x += 15
