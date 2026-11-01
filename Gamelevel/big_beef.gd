extends Control
class_name BigBeef

signal Victory
signal Fed

const BEEF_1 = preload("uid://crfvkohobpdmx")
const BEEF_2 = preload("uid://br0nipoiy07kn")
const BEEF_3 = preload("uid://cw6e7738ku4wa")

@export var Gamenode:GameLevel

var Currentfeed:float
var Requiredfeed:float
var bartarget:float

@onready var barmove: TextureRect = $Bigbar/Bar/Barmove
@onready var bar: Control = $Bigbar/Bar
@onready var beefarea: Sprite2D = $Node2D/Beefarea

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
	chomp()
	barmove.position.y = clampf(bar.size.y-((Currentfeed/Requiredfeed)*bar.size.y),0,bar.size.y)
	if Currentfeed >=Requiredfeed:
		Rounds.Victory()

func openmouth():
	beefarea.texture = BEEF_2

func chomp():
	beefarea.texture = BEEF_3
	await get_tree().create_timer(0.4).timeout
	beefarea.texture = BEEF_1
