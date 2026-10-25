extends Node2D
class_name Sheers

@onready var pivot: Node2D = $Pivot
@onready var pivot_2: Node2D = $Pivot2
var debounce:bool = false

func _process(delta: float) -> void:
	var mousepos = get_viewport().get_mouse_position()
	global_position = mousepos

func _unhandled_input(event: InputEvent) -> void:
	if debounce == true:return
	if event.is_action_pressed("use"):
		IsUsing(false)
	if event.is_action_released("use"):
		IsUsing(true)

func IsUsing(b:bool):
	debounce = true
	var tweenspeedopen = 0.1
	var tweenspeedclose = 0.03
	var toptween = get_tree().create_tween()
	toptween.set_ease(Tween.EASE_OUT)
	var bottween = get_tree().create_tween()
	bottween.set_ease(Tween.EASE_OUT)
	match b:
		true:
			toptween.tween_property(pivot,"rotation",deg_to_rad(-10),tweenspeedopen)
			bottween.tween_property(pivot_2,"rotation",deg_to_rad(10),tweenspeedopen)
		false:
			toptween.tween_property(pivot,"rotation",deg_to_rad(1.4),tweenspeedclose)
			bottween.tween_property(pivot_2,"rotation",deg_to_rad(-1.4),tweenspeedclose)
	debounce = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

func _on_area_2d_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
