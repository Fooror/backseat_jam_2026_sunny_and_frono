extends Node2D
class_name Flower

const FLOWER = preload("uid://7llkqrw6nh1o")
@onready var sprite: Sprite2D = $Sprite

@export var Waterammount:float = 0
@export var Watermax:float = 8

func Bloom():
	sprite.texture = FLOWER
