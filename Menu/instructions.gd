extends Control
class_name Instructions

signal Instructionsdone

var Currentpage:int

@onready var animations: AnimatedSprite2D = $Panel/Paper/Animations
@onready var text: Label = $Panel/Panel/Text
@onready var pagenum: Label = $Panel/Pagenum
@onready var done: Button = $Panel/Done

const Textoneachpage = [
	"Big Beef is hungry and wants fresh produce. It's up to you and your chatroom to grow him some delectable treats.",
	"Use commands in chat to become a fruiting vine.

use 'sprout' to start growing, then use up, down, left, or right to grow in that direction.

once you have enouch branch space, you can use 'leaf' to grow a sugar-producing leaf and 'flower' to make a flower that will eventually turn into a tasty treat.",
	"The watering pail can be used on flower buds to make them bloom and eventually fruit.
	
	Flower buds take one sugar per second, while a bloomed flower or growing fruit takes two sugar per second until ripe.
	
	Make sure to grow pleanty of leaves, as each leaf produces one sugar per second.",
	"once ripe, click on fruit to pick them. then drag them over to big beef's mouth to feed them to him.
feed him enough fruit before dinner's over to make it to the next round.",
	"bugs mimicing leaves will appear on the plant. use the fly swatter to squish them before they suck out all the sugar from the branches. No sugar means no fruits!",
	"If one of the vine's branches are being unruly, use the scissors to sheer off any ammount of that branch.

It'll grow back eventually."
]

func _ready() -> void:
	Currentpage = 0
	text.text = Textoneachpage[0]
	pagenum.text = str(1)+"/6"
	done.hide()


func showandereset():
	Currentpage = 0
	text.text = Textoneachpage[0]
	pagenum.text = str(1)+"/6"
	done.hide()
	show()

func Setpage(page):
	animations.play("page"+str(page+1))
	pagenum.text = str(page+1)+"/6"
	text.text = Textoneachpage[page]
	if page == 5:
		done.show()

func _on_back_pressed() -> void:
	Currentpage = clampi(Currentpage -1,0,5)
	Setpage(Currentpage)

func _on_forward_pressed() -> void:
	Currentpage = clampi(Currentpage +1,0,5)
	Setpage(Currentpage)

func _on_done_pressed() -> void:
	Instructionsdone.emit()
	Rounds.Instructionsread = true
	hide()
