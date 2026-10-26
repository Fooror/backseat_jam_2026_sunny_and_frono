extends Node2D
class_name GameLevel

signal Timeticked

const TREE_SEGMENT = preload("uid://bwfnagv2unacs")
const USERINFO = preload("uid://dn3g0n4mxk8cb")

@onready var treesegments: Node = $World/Treesegments
@onready var timer: Timer = $Timer
@onready var container: GridContainer = $GUI/Container

@onready var camtarget: Node2D = $Camtarget
@export var world:Node2D
@onready var toplevel: Node = $Toplevel
@export var Plantstart:Marker2D
@export var Planttop:Node2D
@export var Camera:Camera2D
func _ready() -> void:
	Twitchhandle.MessageRecieved.connect(chat_message_recieved)

func _physics_process(delta: float) -> void:
	var inp = (Vector2(
		Input.get_action_strength("moveright") - Input.get_action_strength("moveleft"),
		Input.get_action_strength("movedown") - Input.get_action_strength("moveup")
		)).normalized() * 12
	camtarget.position += inp
	Camera.position = Camera.position.lerp(camtarget.position,delta *6)
	
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
	var newuserinfo = USERINFO.instantiate()
	container.add_child(newuserinfo)
	newuserinfo.setup(user)
	newsegment.Infoupdate.connect(newuserinfo.OnInfoUpdated)
	newuserinfo.setup(user)

func _on_timer_timeout() -> void:
	Timeticked.emit()
