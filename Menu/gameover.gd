extends Control

@onready var bestround: Label = $Bestround
@onready var roundnum: Label = $ROUNDNUM

func _ready() -> void:
	bestround.text = ("Best: "+str(Rounds.Bestround))
	roundnum.text = str(Rounds.Currentround)

func _on_return_to_menu_pressed() -> void:
	Rounds.BackToMenu()

func _on_quit_pressed() -> void:
	get_tree().quit()
