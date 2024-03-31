extends Control

## Can't center a checkbox for some unholy reason
## So here's a Control that clicks the checkbox for you

func _ready() -> void:
	await get_tree().process_frame
	if !$CheckBox.button_pressed:
		$"../../..".modulate.a = 0.5

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and !event.is_pressed():
			$CheckBox.button_pressed = !$CheckBox.button_pressed
			
			if $CheckBox.button_pressed:
				$"../../..".modulate.a = 1
			else:
				$"../../..".modulate.a = 0.5
