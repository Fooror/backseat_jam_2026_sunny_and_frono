extends Control
class_name Settingswindow

@onready var menu_confirm: TextureRect = $MenuConfirm
@onready var desktop_confirm: TextureRect = $DesktopConfirm

@onready var music: HScrollBar = $Music
@onready var sfx: HScrollBar = $SFX
@onready var master: HScrollBar = $Master
@onready var control: Controls = $Control
@onready var instructions_2: Instructions = $Instructions2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	instructions_2.hide()
	control.hide()
	menu_confirm.hide()
	desktop_confirm.hide()
	music.set_value_no_signal(Soundhandler.Musicvol)
	sfx.set_value_no_signal(Soundhandler.Soundvol)
	master.set_value_no_signal(Soundhandler.Mastervol)

func showandpause():
	menu_confirm.hide()
	desktop_confirm.hide()
	get_tree().paused = true
	show()

func hideandunpause():
	
	get_tree().paused = false
	control.hide()
	hide()

func _on_music_value_changed(value: float) -> void:
	Soundhandler.set("Musicvol",value)

func _on_sfx_value_changed(value: float) -> void:
	Soundhandler.set("Soundvol",value)

func _on_master_value_changed(value: float) -> void:
	Soundhandler.set("Mastervol",value)

func _on_exit_to_menu_buttton_pressed() -> void:
	menu_confirm.show()

func _on_exit_to_desktop_buttton_pressed() -> void:
	desktop_confirm.show()

func _on_exit_to_menu_pressed() -> void:
	hide()
	Rounds.BackToMenu()

func _on_close_menu_confirm_pressed() -> void:
	menu_confirm.hide()

func _on_exit_to_desktop_pressed() -> void:
	get_tree().quit()

func _on_close_desktop_confirm_pressed() -> void:
	desktop_confirm.hide()

func _on_hide_pressed() -> void:
	hideandunpause()

func _on_check_button_toggled(toggled_on: bool) -> void:
	var mode = DisplayServer.window_get_mode()
	if toggled_on == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	pass

func _on_controls_pressed() -> void:
	control.show()

func _on_instructions_pressed() -> void:
	instructions_2.showandereset()
