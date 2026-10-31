extends Node2D
class_name Branch

signal Snipped

signal Setnewnodeasend(mark:Marker2D)

var Modulated:Color = Color(1.437, 0.291, 0.291)
var NotModulated:Color = Color(1.0, 1.0, 1.0, 1.0)
@export var Branchend:Marker2D
@export var Branchnodes:Node2D
@onready var branch: Node2D = $Branch

@export var Previousbranch:Branch

func getnodes():
	return Branchnodes.get_children()

func hovered():
	modulate = Modulated

func unhovered():
	modulate = NotModulated

func Sheer():
	Snipped.emit()
	Previousbranch.newbranchend()
	queue_free()

func newbranchend():
	Setnewnodeasend.emit(Branchend,self)
