extends Control
class_name Userinfoplate

@onready var username: Label = $Panel/Username
@onready var arrow: TextureRect = $Arrow
@onready var nodes: Label = $Panel/Nodes
@onready var sugar: Label = $Panel/Sugar


func setup(user:String):
	username.text = user

func OnInfoUpdated(availablenodes:int,currentsugar:float,rot:float):
	arrow.rotation = rot
	nodes.text = str(availablenodes)
	sugar.text = str(currentsugar)
	
