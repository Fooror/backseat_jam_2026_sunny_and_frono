extends Node2D

const Waterdrop:float = 1.0

@onready var sprite: Sprite2D = $Sprite
@onready var particles: GPUParticles2D = $Sprite/GPUParticles2D
@onready var water: Node2D = $Water
@onready var line_2d: Line2D = $Water/Line2D

@onready var waterskeleton: Node2D = $Waterskeleton
@onready var _4: CollisionShape2D = $"Area2D/4"
@onready var _3: CollisionShape2D = $"Area2D/3"
@onready var _2: CollisionShape2D = $"Area2D/2"
@onready var _1: CollisionShape2D = $"Area2D/1"

@onready var mark_5: Marker2D = $"Waterskeleton/5"
@onready var mark_4: Marker2D = $"Waterskeleton/4"
@onready var mark_3: Marker2D = $"Waterskeleton/3"
@onready var mark_2: Marker2D = $"Waterskeleton/2"
@onready var mark_1: Marker2D = $"Waterskeleton/1"

@onready var timer: Timer = $Timer

var Wateringplants:Array = []

func _ready() -> void:
	line_2d.width = 0
	line_2d.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use"):
		IsUsing(true)
	if event.is_action_released("use"):
		IsUsing(false)

func _physics_process(delta: float) -> void:
	waterskeleton.position = water.global_position
	global_position = get_viewport().get_mouse_position()
	_4.global_position = _4.global_position.lerp(mark_4.global_position,delta *6)
	_3.global_position = _3.global_position.lerp(mark_3.global_position,delta *12)
	_2.global_position = _2.global_position.lerp(mark_2.global_position,delta *24)
	_1.global_position = _1.global_position.lerp(mark_1.global_position,delta *80)
	
	line_2d.set_point_position(0,line_2d.to_local(water.global_position))
	line_2d.set_point_position(1,line_2d.get_point_position(1).lerp(line_2d.to_local(mark_1.global_position),delta *80))
	line_2d.set_point_position(2,line_2d.get_point_position(2).lerp(line_2d.to_local(mark_2.global_position),delta *24))
	line_2d.set_point_position(3,line_2d.get_point_position(3).lerp(line_2d.to_local(mark_3.global_position),delta *12))
	line_2d.set_point_position(4,line_2d.get_point_position(4).lerp(line_2d.to_local(mark_4.global_position),delta *6))
	line_2d.set_point_position(5,line_2d.get_point_position(5).lerp(line_2d.to_local(mark_5.global_position),delta *4))
	
func IsUsing(b:bool):
	var tweentime = 0.14
	particles.emitting = b
	var pailtween = get_tree().create_tween()
	pailtween.set_ease(Tween.EASE_OUT)
	var waterthictween = get_tree().create_tween()
	waterthictween.set_ease(Tween.EASE_OUT)
	if b == true:
		timer.start(0.3)
		line_2d.show()
		pailtween.tween_property(self,"rotation",deg_to_rad(-60),tweentime)
		waterthictween.tween_property(line_2d,"width",1.2,tweentime)
	else:
		timer.stop()
		pailtween.tween_property(self,"rotation",deg_to_rad(0),tweentime)
		await waterthictween.tween_property(line_2d,"width",0,tweentime).finished
		line_2d.hide()

func _on_timer_timeout() -> void:
	for i in Wateringplants:
		if i.has_method("Water"):
			if i.Water(Waterdrop) == true:
				Wateringplants.erase(i)

func _on_area_2d_area_entered(area: Area2D) -> void:
	Wateringplants.append(area.get_parent())
	print(Wateringplants)

func _on_area_2d_area_exited(area: Area2D) -> void:
	Wateringplants.erase(area.get_parent())
	print(Wateringplants)
