extends Node2D
class_name TreeSegment

signal Infoupdate(availablenodes:int,currentsugar:float,rot:float)

@onready var leftstump: Node2D = $Leftstump
@onready var rightstump: Node2D = $Rightstump
@onready var branchtopper: Node2D = $Branchtopper
@onready var branchcontainer: Node = $Branchcontainer

@export var User:String = "User"
const BRANCH = preload("uid://b0htp8reeoaqb")

@export var SectionTop:Marker2D
@export var Branchstartleft:Marker2D
@export var Branchstartright:Marker2D

@export var leafcontainer: Node
@export var fruitcontainer: Node

var PrevBranch:Branch
var NextBranchNode:Marker2D
var Sugar:int = 0
var Leafcount:int = 0
var Bugcount:int = 0
var Availablenodes:Array[Marker2D]

enum GrowingOnSideEnums {leftly,rightly}

var GrowingOnSide:GrowingOnSideEnums = 0

const Startgrowing = ["sprout"]

const Growthpatterns = ["left","right","up","down","straight"]
const Growthdirrection = [PI,2.0*PI,(3.0*PI)/2.0,PI/2.0,null,3.85,5.5]

const Growthprompts = ["leaf","flower"]

const GrowthnodesPaths = ["res://Gamelevel/leaf.tscn","res://Gamelevel/flower.tscn"]

var debounce:bool = false

func _ready() -> void:
	leftstump.hide()
	rightstump.hide()

func setup(username:String,message:String):
	User = username
	makestartbranch(message)
  
func setdebounce():
	debounce = true
	await get_tree().create_timer(1.5).timeout
	debounce = false

func ontimertick():
	Sugar += 2*Leafcount

func messaged(message:String):
	if debounce == true:return
	setdebounce()
	for i in Growthprompts.size():
		if message == Growthprompts[i]:
			grownode(GrowthnodesPaths[i],Growthprompts[i])
			return
	for i in Growthpatterns.size():
		if message == Growthpatterns[i]:
			growsegment(Growthdirrection[i])
			return

func makestartbranch(message:String):
	var startmarker:Marker2D
	if message == "left":
		startleftly()
		growsegment(Growthdirrection[5])
		return
	if message == "right":
		startrightly()
		growsegment(Growthdirrection[6])
		return
	
	if randi_range(0,1) == 0:
		startleftly()
		growsegment(Growthdirrection[5])
	else:
		startrightly()
		growsegment(Growthdirrection[6])

func startleftly():
	branchtopper.scale.x = -1
	GrowingOnSide = GrowingOnSideEnums.leftly
	leftstump.show()
	NextBranchNode = Branchstartleft

func startrightly():
	GrowingOnSide = GrowingOnSideEnums.rightly
	rightstump.show()
	NextBranchNode = Branchstartright

func growsegment(dir):
	var branch:Branch = BRANCH.instantiate()
	branchcontainer.add_child(branch)
	branch.global_position = NextBranchNode.global_position
	if PrevBranch:
		if dir == null: branch.rotation = PrevBranch.rotation
		else:
			var angle = lerp_angle(PrevBranch.rotation,dir,0.5)
			var add = clampf(angle - PrevBranch.rotation,-1.2,1.2)
			if add > 0.4 or add < -0.4:
				branch.rotation = PrevBranch.rotation + add
			else:
				branch.rotation = wrapf(dir,0.0,TAU)
	else:
		branch.rotation = wrapf(dir,0.0,TAU)
	Infoupdate.emit(Availablenodes.size(),Sugar,branch.rotation)
	
	print (branch.rotation)
	NextBranchNode.queue_free()
	Availablenodes.append_array(branch.Branchnodes)
	NextBranchNode = branch.Branchend
	PrevBranch = branch
	branchtopper.global_position = branch.Branchend.global_position
	branchtopper.rotation = branch.rotation

func findavailablenode():
	var randi:int
	if Availablenodes.size() <= 0: return
	randi = randi_range(0,Availablenodes.size()-1)
	var chosen = Availablenodes[randi]
	Availablenodes.remove_at(randi)
	return chosen

func grownode(growth:String,growstring:String):
	var node = findavailablenode()
	if node == null: return
	var loadedgrowth = load(growth).instantiate()
	match growstring:
		"leaf":
			leafcontainer.add_child(loadedgrowth)
			loadedgrowth.global_position = node.global_position
		"flower":
			fruitcontainer.add_child(loadedgrowth)
			loadedgrowth.global_position = node.global_position
			loadedgrowth.progress_bar.global_position = loadedgrowth.global_position + Vector2(-(loadedgrowth.progress_bar.size.x/2),20)
	var scale = randf_range(0.9,1.1)
	loadedgrowth.scale = Vector2(scale,scale)
	if randi_range(0,1) == 0:
		loadedgrowth.scale.x = -(loadedgrowth.scale.x)
	loadedgrowth.rotation = node.rotation + node.get_parent().get_parent().rotation + deg_to_rad(randf_range(-10,10))
	node.queue_free
