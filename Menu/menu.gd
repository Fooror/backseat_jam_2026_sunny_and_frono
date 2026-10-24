extends Control

@onready var text_edit: TextEdit = $TextEdit
@onready var connect: Button = $Connect
@onready var startgamebutton: Button = $Startgame
@onready var rich_text_label: RichTextLabel = $RichTextLabel

func _ready() -> void:
	Twitchhandle.ChatConnected.connect(connected)

func connected(channelname:String):
	rich_text_label.text = ("Successfully connected to "+channelname+"!")
	startgamebutton.disabled = false

func _on_connect_pressed() -> void:
	Twitchhandle.Connect_chat(text_edit.text)

func _on_startgame_pressed() -> void:
	get_tree().change_scene_to_file("res://Gamelevel/game_level.tscn")
