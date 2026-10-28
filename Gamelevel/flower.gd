extends Node2D
class_name Flower

signal Sheered
signal Fruited

const FLOWER = preload("uid://7llkqrw6nh1o")
@onready var sprite: Sprite2D = $Sprite
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var area_2d: Area2D = $Area2D

@export var Currentgrowth:float = 0
const Maxgrowth:float = 16

@export var floweropen:bool = false

@export var Waterammount:float = 0.0
var Watermax:float = 16.0

func Water(val:float) -> bool:
	Waterammount +=val
	SetBar()
	if Waterammount >= Watermax:
		Bloom()
		return true
	return false

func Bloom():
	area_2d.set_collision_layer_value(2,false)
	area_2d.set_collision_layer_value(3,true)
	sprite.texture = FLOWER
	progress_bar.hide()
	floweropen = true

func Growflower():
	Currentgrowth += 1
	print (Currentgrowth)
	if Currentgrowth >= Maxgrowth:
		Fruited.emit(self)

func _ready() -> void:
	progress_bar.max_value = Watermax
	progress_bar.value = 0.0

func SetBar() -> void:
	progress_bar.value = Waterammount
	if progress_bar.value >= Watermax:
		Bloom()

func Sheer():
	area_2d.set_collision_layer_value(3,false)
	
	pass
