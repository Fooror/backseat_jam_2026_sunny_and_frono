extends Node2D
class_name TreeSegment

signal Infoupdate(availablenodes:int,currentsugar:float,rot:float)

@onready var leftstump: Node2D = $Leftstump
@onready var rightstump: Node2D = $Rightstump
@onready var branchtopper: Node2D = $Branchtopper
@onready var pivot: Node2D = $Branchtopper/Pivot
@onready var branchcontainer: Node = $Branchcontainer
@onready var sign: Control = $Sign
@onready var signhandle: Control = $Sign/Signhandle
@onready var username_backboard: NinePatchRect = $Sign/UsernameBackboard
@onready var username_label: Label = $Sign/UsernameLabel

@export var Gamenode:GameLevel

@export var User:String = "User"

const BRANCH = preload("uid://b0htp8reeoaqb")
const LEAFY = preload("uid://ctte7lxe6exo0")

const APPLE = [preload("uid://bfcqcn4mvnf8g"),15]
const BANANA = [preload("uid://cehwtdjo830sg"),13]
const BLUEBERRY = [preload("uid://6ri6ovwclibk"),10]
const CARROT = [preload("uid://c85bhtmc5jmc1"),8]
const CHERRY = [preload("uid://dfbc32p18tpbn"),12]
const CORN = [preload("uid://vp8m4htsjmuo"),8]
const DRAGONFRUIT = [preload("uid://bdi8305yba1be"),5]
const EGGPLANT = [preload("uid://dunbhfm31gyxs"),10]
const GOLDTOMATO = [preload("uid://djwak1w0k8uof"),3]
const JACKFRUIT = [preload("uid://tup3t1hcsoqd"),8]
const MANGOSTEEN = [preload("uid://ut7st8hbueeg"),12]
const ORANGE = [preload("uid://d2tn4r4oxwhqg"),16]
const PEA = [preload("uid://bwrc7xg45h7qj"),15]
const PEACH = [preload("uid://ch13gwwil1cv6"),12]
const PEAR = [preload("uid://bxvqmhjiqrabt"),12]
const PEPPER = [preload("uid://drbju0e055di"),10]
const POM = [preload("uid://cda1pyfmvtvxu"),6]
const PUMPKIN = [preload("uid://c2ey8xr8furgl"),5]
const STRAWBERRY = [preload("uid://1kxya83dy6pn"),14]
const TOMATO = [preload("uid://cmq1tq1cmh5l3"),18]
const WATERMELON = [preload("uid://cctuhe0rvfpnn"),5]

const FRUITS = [APPLE,BANANA,BLUEBERRY,CARROT,CHERRY,CORN,DRAGONFRUIT,EGGPLANT,GOLDTOMATO,JACKFRUIT,MANGOSTEEN,ORANGE,PEA,PEACH,PEAR,PEPPER,POM,PUMPKIN,STRAWBERRY,TOMATO,WATERMELON]

@export var SectionTop:Marker2D
@export var Branchstartleft:Marker2D
@export var Branchstartright:Marker2D

@export var leafcontainer: Node
@export var fruitcontainer: Node
@export var flowercontainer: Node2D
@export var bugcontainer: Node2D

var PrevBranch:Branch
var NextBranchNode:Marker2D
var Sugar:int = 0
var Bugcount:int = 0

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
	Sugar += 1*leafcontainer.get_child_count()
	Sugar = sugartobug(Sugar)
	Sugar = sugartofruits(Sugar)
	Sugar = sugartoflowers(Sugar)
	Sugar = clampf(Sugar,0,999)
	var rotation = 0.0
	if PrevBranch:
		rotation = PrevBranch.rotation
	Infoupdate.emit(getavailablenodes().size(),Sugar,rotation)

func sugartobug(sugar:int):
	var remainingsugar = sugar
	if bugcontainer.get_child_count() == 0:
		return sugar
	for i:Leafy in bugcontainer.get_children():
		if i.Squished == false:
			if remainingsugar >=6:
				remainingsugar -=6
			else:
				return remainingsugar
	return remainingsugar

func sugartofruits(sugar:int):
	var remainingsugar = sugar
	if fruitcontainer.get_child_count() == 0:
		return sugar
	for i:Fruit in fruitcontainer.get_children():
		if i.Finishedgrowing == false:
			if remainingsugar >=2:
				remainingsugar -=2
				i.growthtick()
			else:
				return remainingsugar
	return remainingsugar

func sugartoflowers(sugar:int):
	var remainingsugar = sugar
	if flowercontainer.get_child_count() == 0:
		return sugar
	for i:Flower in flowercontainer.get_children():
		if i.floweropen == true:
			if remainingsugar >=2:
				remainingsugar -=2
				i.Growflower()
			else:
				return remainingsugar
		else:
			if remainingsugar >=1:
				remainingsugar -=1
			else:
				return remainingsugar
	return remainingsugar

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
	sign.global_position = Branchstartleft.global_position
	NextBranchNode = Branchstartleft

func startrightly():
	GrowingOnSide = GrowingOnSideEnums.rightly
	rightstump.show()
	signhandle.scale.x =-1
	pivot.scale.x = -1
	sign.global_position = Branchstartright.global_position
	
	NextBranchNode = Branchstartright

func growsegment(d):
	var dir = d
	if PrevBranch:
		if PrevBranch.global_position.y >= 800:
			if GrowingOnSide == GrowingOnSideEnums.leftly:
				dir = Growthdirrection[0]
			else:
				dir = Growthdirrection[1]
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
		PrevBranch.Snipped.connect(branch.Sheer)
		branch.Previousbranch = PrevBranch
	else:
		branch.rotation = wrapf(dir,0.0,TAU)
	NextBranchNode = branch.Branchend
	branch.Setnewnodeasend.connect(newbranchend)
	PrevBranch = branch
	branchtopper.global_position = branch.Branchend.global_position
	branchtopper.rotation = branch.global_rotation
	Infoupdate.emit(getavailablenodes().size(),Sugar,branch.rotation)

func newbranchend(mark:Marker2D,branch):
	print ("prev branch set")
	NextBranchNode = mark
	PrevBranch = branch
	branchtopper.global_position = NextBranchNode.global_position
	branchtopper.global_rotation = PrevBranch.global_rotation
	Infoupdate.emit(getavailablenodes().size(),Sugar,branch.rotation)

func getavailablenodes():
	var nodes
	nodes = []
	for i:Branch in branchcontainer.get_children():
		nodes.append_array(i.getnodes())
	return nodes

func findavailablenode():
	var randi:int
	if branchcontainer.get_child_count() <= 0: return
	var nodes = getavailablenodes()
	if getavailablenodes().size() <=0: return
	randi = randi_range(0,nodes.size()-1)
	var chosen = nodes[randi]
	print (chosen)
	return chosen

func growfruit(flower:Flower):
	var newfruit:Fruit = choosefruit().instantiate()
	fruitcontainer.add_child(newfruit)
	newfruit.position = flower.position
	flower.queue_free()
	newfruit.Picked.connect(Gamenode.Pickfruit)
	flower.branch.Snipped.connect(newfruit.Sheer)
	newfruit.Prevbranch = flower.branch
	newfruit.setup(Gamenode)

func choosefruit():
	var addednumber:int
	addednumber = 0
	for i in FRUITS:
		addednumber += i[1]
	var fruit
	fruit = FRUITS[19][0]
	var roll:int
	roll = randi_range(0,addednumber)
	while roll >0:
		for i in range (FRUITS.size()):
			fruit = FRUITS[i][0]
			roll -= FRUITS[i][1]
			if roll <=0 : return fruit
	return fruit

func setsign(username:String):
	var padding:float = 60.0
	username_label.text = username
	await get_tree().process_frame
	username_label.position = Vector2(-username_label.size.x/2,username_label.position.y)
	username_backboard.size.x = username_label.size.x + padding
	username_backboard.position = Vector2(-username_backboard.size.x/2,username_backboard.position.y)

func spawnbug():
	if getavailablenodes().size() <= 0: return
	var chosennode = findavailablenode()
	var newbug:Leafy = LEAFY.instantiate()
	bugcontainer.add_child(newbug)
	newbug.global_position = chosennode.global_position
	newbug.global_rotation = chosennode.global_rotation + rad_to_deg(randf_range(-45,45))
	newbug.PrevRotation = chosennode.global_rotation
	var branch:Branch = chosennode.get_parent().get_parent().get_parent()
	newbug.PrevBranch = branch
	branch.Snipped.connect(newbug.Sheer)
	chosennode.queue_free()
	newbug.Smashsignal.connect(replenishnodefrombug)
	Infoupdate.emit(getavailablenodes().size(),Sugar,PrevBranch.rotation)

func replenishnodefrombug(bug:Leafy):
	var newnode2d = Marker2D.new()
	bug.PrevBranch.add_child(newnode2d)
	newnode2d.global_position = bug.global_position
	newnode2d.global_rotation = bug.PrevRotation
	Infoupdate.emit(getavailablenodes().size(),Sugar,PrevBranch.rotation)

func grownode(growth:String,growstring:String):
	var node = findavailablenode()
	if node == null: return
	var loadedgrowth = load(growth).instantiate()
	match growstring:
		"leaf":
			leafcontainer.add_child(loadedgrowth)
			loadedgrowth.global_position = node.global_position
		"flower":
			flowercontainer.add_child(loadedgrowth)
			loadedgrowth.global_position = node.global_position
			loadedgrowth.progress_bar.global_position = loadedgrowth.global_position + Vector2(-(loadedgrowth.progress_bar.size.x/2),20)
			loadedgrowth.Fruited.connect(growfruit)
			loadedgrowth.branch = node.get_parent().get_parent().get_parent()
	var branch:Branch = node.get_parent().get_parent().get_parent()
	branch.Snipped.connect(loadedgrowth.Sheer)
	var scale = randf_range(0.9,1.1)
	loadedgrowth.scale = Vector2(scale,scale)
	if randi_range(0,1) == 0:
		loadedgrowth.scale.x = -(loadedgrowth.scale.x)
	loadedgrowth.rotation = node.rotation + node.get_parent().get_parent().rotation + deg_to_rad(randf_range(-10,10))
	node.queue_free()
	Infoupdate.emit(getavailablenodes().size(),Sugar,PrevBranch.rotation)
