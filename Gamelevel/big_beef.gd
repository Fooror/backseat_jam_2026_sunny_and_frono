extends Control
class_name BigBeef

signal Victory

@export var Gamenode:GameLevel

var Currentfeed:float
var Requiredfeed:float

var bartarget:float

@onready var barmove: TextureRect = $Bigbar/Bar/Barmove
@onready var bar: Control = $Bigbar/Bar

func _process(delta: float) -> void:
	barmove.position.lerp(Vector2(barmove.position.x,bartarget),delta*2)

func newround(round:int):
	var roundfl = float(round)
	Requiredfeed = 4+(roundfl)^(1.8)
	Currentfeed = 0
	barmove.position.y = bar.size.y

func _on_feedzone_mouse_entered() -> void:
	if Gamenode.holdingfruit == false:return
	Gamenode.holdingfruit = false
	Currentfeed += Gamenode.heldfruitvalue
	Gamenode.heldfruitvalue = 0
	Gamenode.fruitsprite = null
	bartarget = (Currentfeed/Requiredfeed)*bar.size.y
	if Currentfeed >=Requiredfeed:
		Victory.emit()
