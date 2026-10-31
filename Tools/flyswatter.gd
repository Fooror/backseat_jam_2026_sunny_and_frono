extends Node2D
class_name Swatter

var ToSlap:Array[Leafy] = []

@onready var area_2d: Area2D = $Pivot/Swatta/Area2D
@onready var pivot: Node2D = $Pivot
const SPLATTER = preload("uid://cksw30tjwbpmb")

func _process(delta: float) -> void:
	global_position = get_parent().get_global_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use"):
		IsUsing(true)
	if event.is_action_released("use"):
		IsUsing(false)

func IsUsing(b:bool):
	var tweenintime = 0.01
	var tweenouttime = 0.08
	var swattween = get_tree().create_tween()
	swattween.set_ease(Tween.EASE_OUT)
	if b == true:
		createslap()
		swattween.tween_property(pivot,"rotation",deg_to_rad(-8.0),tweenintime)
		Soundhandler.playsound(Soundhandler.Soundenum.slap,global_position)
		for i:Leafy in ToSlap:
			i.splat()
	else:
		swattween.tween_property(pivot,"rotation",deg_to_rad(0),tweenouttime)

func createslap():
	var sprite = Sprite2D.new()
	sprite.texture = SPLATTER
	sprite.scale = Vector2(0.6,0.6)
	get_parent().add_child(sprite)
	sprite.global_position = area_2d.global_position
	var tween = get_tree().create_tween()
	tween.tween_property(sprite,"scale",Vector2(1.0,1.0),0.08)
	await tween.finished
	sprite.queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	ToSlap.append(area.get_parent())

func _on_area_2d_area_exited(area: Area2D) -> void:
	ToSlap.erase(area.get_parent())
