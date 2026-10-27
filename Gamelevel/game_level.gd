extends Node2D
class_name GameLevel

signal Timeticked

const TREE_SEGMENT = preload("uid://bwfnagv2unacs")
const USERINFO = preload("uid://dn3g0n4mxk8cb")

@onready var treesegments: Node = $World/Treesegments
@onready var timer: Timer = $Timer
@onready var round: Timer = $Round
@onready var container: GridContainer = $GUI/Container

@onready var camtarget: Node2D = $Camtarget
@onready var toplevel: Node = $Toplevel
@export var world:Node2D
@export var Plantstart:Marker2D
@export var Planttop:Node2D
@export var Camera:Camera2D

var zoomtarget:float = 1

func _ready() -> void:
	Twitchhandle.MessageRecieved.connect(chat_message_recieved)

func _physics_process(delta: float) -> void:
	var inp = (Vector2(
		Input.get_action_strength("moveright") - Input.get_action_strength("moveleft"),
		Input.get_action_strength("movedown") - Input.get_action_strength("moveup")
		)).normalized() * 12
	camtarget.position += inp
	Camera.position = Camera.position.lerp(camtarget.position,delta *6)
	Camera.zoom = Camera.zoom.lerp(Vector2(zoomtarget,zoomtarget),delta *6)
	if Input.is_action_just_pressed("mousescrolldown"):
		zoomtarget = clampf(zoomtarget - 0.1,0.1,2)
	if Input.is_action_just_pressed("mousescrollup"):
		zoomtarget = clampf(zoomtarget + 0.1,0.1,2)

func chat_message_recieved(user:String,message:String):
	for i:TreeSegment in treesegments.get_children():
		if i.User == user:
			i.messaged(message)
			return
	setupnewuser(user,message)

func setupnewuser(user:String,message:String):
	print("new user:"+user)
	var newsegment:TreeSegment = TREE_SEGMENT.instantiate()
	treesegments.add_child(newsegment)
	newsegment.global_position = Planttop.global_position
	Planttop.global_position = newsegment.SectionTop.global_position
	newsegment.setup(user,message)
	Timeticked.connect(newsegment.ontimertick)
	var newuserinfo = USERINFO.instantiate()
	container.add_child(newuserinfo)
	newuserinfo.setup(user)
	newsegment.Infoupdate.connect(newuserinfo.OnInfoUpdated)
	newuserinfo.setup(user)

func NewRound():
	pass

func Victory():
	pass

func GameOver():
	pass

func NewGame():
	pass

func _on_timer_timeout() -> void:
	Timeticked.emit()

func _on_round_timeout() -> void:
	pass # Replace with function body.
