extends Panel
class_name ModPanel

static var selected_panel: ModPanel

var is_mouse_over: bool
var start_color: Color

func _ready() -> void:
	start_color = self_modulate

func flash_panel():
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	
	var current_color: Color = self_modulate
	tween.tween_property(self, "self_modulate", current_color, 0.75).from(Color("ffff00"))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_released():
			if is_mouse_over:
				if selected_panel and selected_panel != self:
					selected_panel.deselect_panel()
				select_panel()
			else:
				await get_tree().process_frame
				if selected_panel and selected_panel == self:
					deselect_panel()

func select_panel() -> void:
	self_modulate = Color.DARK_CYAN
	selected_panel = self

func deselect_panel() -> void:
	self_modulate = start_color


func _on_mouse_entered() -> void:
	is_mouse_over = true
	if self != selected_panel:
		self_modulate = self_modulate.lightened(0.25)

func _on_mouse_exited() -> void:
	is_mouse_over = false
	if self != selected_panel:
		self_modulate = start_color
