extends Control
class_name Userinfoplate

@onready var username: Label = $Panel/Username

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setup(user:String):
	username.text = user

func OnInfoUpdated():
	pass
