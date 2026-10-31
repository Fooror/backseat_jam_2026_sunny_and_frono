extends Node2D
class_name Leafy

signal Smashsignal(leaf:Leafy)

@export var Squished:bool = false
@export var PrevRotation:float
@export var PrevBranch:Branch

@onready var bugsprite: Sprite2D = $Bugsprite
@onready var splatsprite: Sprite2D = $Splatsprite
@onready var area_2d: Area2D = $Area2D

const BUG_1 = preload("uid://c67arn52maywd")
const BUG_2 = preload("uid://svjag44pasrp")
const BUG_3 = preload("uid://dnfa6crbo5ckx")

var bugs = [BUG_1,BUG_2,BUG_3]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	splatsprite.hide()
	setup()

func setup():
	var chosen = randi_range(0,2)
	bugsprite.texture = bugs[chosen]

func splat():
	Squished = true
	area_2d.monitorable = false
	bugsprite.hide()
	#play noise
	splatsprite.show()
	Smashsignal.emit(self)
	await get_tree().create_timer(3).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(splatsprite,"modulate",Color(0.0, 0.0, 0.0, 0.0),2)
	await tween.finished
	queue_free()
	
func Sheer():
	area_2d.set_collision_layer_value(5,false)
	queue_free()
