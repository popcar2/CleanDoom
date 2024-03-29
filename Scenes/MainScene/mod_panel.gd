extends Panel
class_name ModPanel

func flash_panel():
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	
	var current_color: Color = self_modulate
	tween.tween_property(self, "self_modulate", current_color, 0.75).from(Color("ffff00"))
