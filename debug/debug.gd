extends CanvasLayer

@onready var text_edit: TextEdit = $TextEdit
@onready var line_edit: LineEdit = $LineEdit

func _on_button_pressed() -> void:
	Twitchhandle.MessageRecieved.emit(line_edit.text,text_edit.text)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open debug"):
		if visible == true: hide()
		else: show()

func _unhandled_key_input(event: InputEvent) -> void:
	if text_edit.has_focus():
		get_viewport().set_input_as_handled()
