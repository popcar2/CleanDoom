extends Control

## Can't center a checkbox for some unholy reason
## So here's a Control that clicks the checkbox for you

var is_mouse_over: bool

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and is_mouse_over:
		if event.button_index == 1 and !event.is_pressed():
			$CheckBox.button_pressed = !$CheckBox.button_pressed


func _on_mouse_entered() -> void:
	is_mouse_over = true


func _on_mouse_exited() -> void:
	is_mouse_over = false
