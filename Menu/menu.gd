extends Control
class_name Menuscreen

signal Newgame(s)

@onready var text_edit: LineEdit = $TextEdit

@onready var connect: Button = $Connect
@onready var startgamebutton: Button = $Startgame
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var control: Control = $Control
@onready var instructions_2: Control = $Instructions2

func _ready() -> void:
	Twitchhandle.ChatConnected.connect(connected)

func connected(channelname:String):
	rich_text_label.text = ("Successfully connected to "+channelname+"!")
	startgamebutton.disabled = false

func _on_connect_pressed() -> void:
	Twitchhandle.Connect_chat(text_edit.text)

func _on_startgame_pressed() -> void:
	Rounds.NewGame()

func _on_text_edit_text_submitted(new_text: String) -> void:
	Twitchhandle.Connect_chat(new_text)

func _on_instructions_pressed() -> void:
	instructions_2.showandereset()

func _on_settings_pressed() -> void:
	Rounds.settings.show()

func _on_commands_pressed() -> void:
	control.show()
