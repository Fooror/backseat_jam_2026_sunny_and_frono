extends Node2D
class_name Fruit

signal Picked(s:Fruit)

@export var Fruitsprite:Sprite2D
@export var Fruitvalue:float

@onready var fruit: Node2D = $Fruit
@onready var dangly: Node2D = $Dangly
@onready var area_2d: Area2D = $Area2D
@onready var control: Control = $Control


@export var Finishedgrowing:bool = false

var Tickvalue:float = 0.1
var Growthvalue:float = 1.0
var Maxgrowth:float = 4.0


const Growthvalues = [1.0,2.0,3.0,4.0]

#[fruitscale,danglyscale,fruitpos,danglyvisible,fruitmod]
const Growthstage:Dictionary = {
	"1" = [Vector2(0.24,0.24),Vector2(1.0,1.0),Vector2(0.0,24.0),true,Color(0.0, 2.128, 0.515)],
	"2" = [Vector2(0.4,0.4),Vector2(0.8,0.8),Vector2(0.0,16.0),true,Color(0.29, 1.205, 0.0)],
	"3" = [Vector2(0.6,0.6),Vector2(0.5,0.5),Vector2(0.0,8.0),true,Color(0.5, 1.117, 0.403)],
	"4" = [Vector2(0.8,0.8),Vector2(0.5,0.5),Vector2(0.0,0.0),false,Color(1.0, 1.0, 1.0, 1.0)]
}

func _ready() -> void:
	control.hide()

func growthtick():
	Growthvalue += Tickvalue
	Growthvalue = snappedf(Growthvalue,0.01)
	var growth:String = growthstage()
	setstage(growth)
	if Growthvalue >= Maxgrowth:
		Finishedgrowing = true
		print ("finished growing")
		area_2d.set_collision_layer_value(3,false)
		control.show()

func growthstage():
	if Growthvalue >= Growthvalues[3]:
		return "4"
	if Growthvalue >= Growthvalues[2]:
		return "3"
	if Growthvalue >= Growthvalues[1]:
		return "2"
	if Growthvalue >= Growthvalues[0]:
		return "1"

func setup():
	setstage("1")

func setstage(stage:String):
	fruit.scale = Growthstage[stage][0]
	dangly.scale = Growthstage[stage][1]
	fruit.position = Growthstage[stage][2]
	dangly.visible = Growthstage[stage][3]
	fruit.modulate = Growthstage[stage][4]

func _on_control_gui_input(event: InputEvent) -> void:
	if Finishedgrowing == false:return
	if event is InputEventMouse and event is not InputEventMouseMotion:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("picked")
			Picked.emit(self)
