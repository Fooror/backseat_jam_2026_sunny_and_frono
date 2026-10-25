extends Node2D
class_name Flower

const FLOWER = preload("uid://7llkqrw6nh1o")
@onready var sprite: Sprite2D = $Sprite
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var area_2d: Area2D = $Area2D

@export var timer: Timer

@export var Waterammount:float = 0.0
var Watermax:float = 16.0

func Bloom():
	timer.stop()
	area_2d.set_collision_layer_value(2,false)
	area_2d.set_collision_layer_value(3,true)
	sprite.texture = FLOWER
	progress_bar.hide()

func _ready() -> void:
	progress_bar.max_value = Watermax
	progress_bar.value = 0.0

func _on_timer_timeout() -> void:
	Waterammount += 1.0
	print(Waterammount)
	progress_bar.value = Waterammount
	if progress_bar.value >= Watermax:
		Bloom()
