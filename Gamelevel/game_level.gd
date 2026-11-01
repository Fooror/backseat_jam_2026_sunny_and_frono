extends Node2D
class_name GameLevel

signal Timeticked

signal Emitfeeding(fruitval:float)

const TREE_SEGMENT = preload("uid://bwfnagv2unacs")
const USERINFO = preload("uid://dn3g0n4mxk8cb")
const CUTNUB = preload("uid://b125b63fytl7h")

var Currentround:int

@export var fruit_cursor: Node2D
@export var fruitsprite: Sprite2D
@export var holdingfruit:bool = false
@export var heldfruitvalue:float = 0

@onready var treesegments: Node = $World/Treesegments
@onready var timer: Timer = $Timer
@onready var round: Timer = $Round
@onready var bug: Timer = $Bug
@onready var container: GridContainer = $GUI/Container
@onready var ground: Node2D = $World/Ground

@onready var camtarget: Node2D = $Camtarget
var zoomtarget:float = 1
@onready var toplevel: Node = $Toplevel
@export var world:Node2D
@export var Plantstart:Marker2D
@export var Planttop:Node2D
@export var Camera:Camera2D
@export var Bigbeef:BigBeef

func _ready() -> void:
	Twitchhandle.MessageRecieved.connect(chat_message_recieved)
	Bigbeef.Fed.connect(Feed)
	Emitfeeding.connect(Bigbeef.Feeding)
	bug.start(10.0)

func bugtime():
	if treesegments.get_child_count() > 0:
		var timecalc = (randf_range(16,24))/treesegments.get_child_count()
		return timecalc
	else:
		return 10

func _physics_process(delta: float) -> void:
	fruit_cursor.global_position = get_global_mouse_position()
	var inp = (Vector2(
		Input.get_action_strength("moveright") - Input.get_action_strength("moveleft"),
		Input.get_action_strength("movedown") - Input.get_action_strength("moveup")
		)).normalized() * 12
	camtarget.position += inp
	camtarget.position.y = clampf(camtarget.position.y,-10000000,400)
	Camera.position = Camera.position.lerp(camtarget.position,delta *6)
	Camera.zoom = Camera.zoom.lerp(Vector2(zoomtarget,zoomtarget),delta *6)
	if Input.is_action_just_pressed("mousescrolldown"):
		zoomtarget = clampf(zoomtarget - 0.1,0.1,1.9)
	if Input.is_action_just_pressed("mousescrollup"):
		zoomtarget = clampf(zoomtarget + 0.1,0.1,1.9)
	var Camposforground = floor(Camera.position.x/1920)
	ground.position.x = Camposforground*1920

func chat_message_recieved(user:String,message:String):
	for i:TreeSegment in treesegments.get_children():
		if i.User == user:
			i.messaged(message)
			return
	if message.to_lower() == "sprout":
		setupnewuser(user,message)

func bugspawn():
	if treesegments.get_child_count() >0:
		var chosen:TreeSegment = treesegments.get_children()[randi_range(0,treesegments.get_child_count()-1)]
		chosen.spawnbug.call_deferred()
	bug.start(clampf((randf_range(16,26))/treesegments.get_child_count(),0.3,26))

func setupnewuser(user:String,message:String):
	print("new user:"+user)
	var newsegment:TreeSegment = TREE_SEGMENT.instantiate()
	treesegments.add_child(newsegment)
	newsegment.global_position = Planttop.global_position
	Planttop.global_position = newsegment.SectionTop.global_position
	newsegment.setup(user,message)
	newsegment.setsign(user)
	newsegment.Gamenode = self
	Timeticked.connect(newsegment.ontimertick)
	var newuserinfo = USERINFO.instantiate()
	container.add_child(newuserinfo)
	newuserinfo.setup(user)
	newsegment.Infoupdate.connect(newuserinfo.OnInfoUpdated)

func Pickfruit(fruit:Fruit):
	holdingfruit = true
	Soundhandler.playsound(Soundhandler.Soundenum.pop,fruit.global_position)
	fruit_cursor.show()
	fruitsprite.texture = fruit.Fruitsprite.texture
	heldfruitvalue = fruit.Fruitvalue
	var nub = CUTNUB.instantiate()
	fruit.Prevbranch.add_child(nub)
	nub.global_position = fruit.global_position
	nub.global_rotation = fruit.Prevbranch.global_rotation
	fruit.Prevbranch.Snipped.connect(nub.Sheer)
	fruit.queue_free()

func Feed():
	holdingfruit = false
	fruit_cursor.hide()
	Emitfeeding.emit(heldfruitvalue)

func _on_timer_timeout() -> void:
	Timeticked.emit()

func _on_bug_timeout() -> void:
	bugspawn()

func _on_cam_center_pressed() -> void:
	camtarget.position = Vector2(0.0,0.0)
