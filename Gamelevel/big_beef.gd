extends Control
class_name BigBeef

signal Victory
signal Fed

@export var Gamenode:GameLevel

var Currentfeed:float
var Requiredfeed:float
var bartarget:float

@onready var barmove: TextureRect = $Bigbar/Bar/Barmove
@onready var bar: Control = $Bigbar/Bar

func _ready() -> void:
	newround(Rounds.Currentround)

func newround(round:int):
	var roundfl = float(round)
	Requiredfeed = 4+pow(roundfl,1.8)
	Currentfeed = 0
	barmove.position.y = bar.size.y

func _on_feedzone_mouse_entered() -> void:
	if Gamenode.holdingfruit == false:return
	Fed.emit()

func Feeding(fruitval:float):
	Currentfeed += fruitval
	barmove.position.y = clampf(bar.size.y-((Currentfeed/Requiredfeed)*bar.size.y),0,bar.size.y)
	if Currentfeed >=Requiredfeed:
		Rounds.Victory()
