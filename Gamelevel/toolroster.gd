extends Panel
class_name ToolRoster

const WATERING_PAIL = preload("uid://bxvs7fc8vrxr")
const SHEARS = preload("uid://qtr5pwipprp3")

const SCISSORS_FULL = preload("uid://cyht4jijbyttm")
const SWATTA = preload("uid://b260dccpbj8nk")
const WATERING_CAN = preload("uid://dpbnra5ofqoql")

@onready var pail: Button = $pail
@onready var slap: Button = $slap
@onready var shear: Button = $shear

enum ToolEnums {none,pail,slap,shear}
var Currenttool:ToolEnums = ToolEnums.none

@export var Toolcontainernode:Node

func _on_pail_pressed() -> void:
	unequipall()
	if Currenttool == ToolEnums.pail:
		Currenttool = ToolEnums.none
		return
	Currenttool = ToolEnums.pail
	pail.icon = null
	Toolcontainernode.add_child(WATERING_PAIL.instantiate())

func _on_slap_pressed() -> void:
	unequipall()
	if Currenttool == ToolEnums.slap:
		Currenttool = ToolEnums.none
		return

func _on_shear_pressed() -> void:
	unequipall()
	if Currenttool == ToolEnums.shear:
		Currenttool = ToolEnums.none
		return
	Currenttool = ToolEnums.shear
	shear.icon = null
	Toolcontainernode.add_child(SHEARS.instantiate())

func unequipall():
	shear.icon = SCISSORS_FULL
	slap.icon = SWATTA
	pail.icon = WATERING_CAN
	for i in Toolcontainernode.get_children():
		i.queue_free()
