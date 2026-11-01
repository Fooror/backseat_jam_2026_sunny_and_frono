extends Node2D
class_name Sheers

@onready var pivot: Node2D = $Pivot
@onready var pivot_2: Node2D = $Pivot2

var Hovered = []

var debounce:bool = false

func _ready() -> void:
	IsUsing(true)

func _process(delta: float) -> void:
	global_position = get_parent().get_global_mouse_position()

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
			Soundhandler.playsound(Soundhandler.Soundenum.clip,self.global_position)
			toptween.tween_property(pivot,"rotation",deg_to_rad(-10),tweenspeedopen)
			bottween.tween_property(pivot_2,"rotation",deg_to_rad(10),tweenspeedopen)
			if Hovered.size() >0:
				Hovered[0].Sheer()
		false:
			toptween.tween_property(pivot,"rotation",deg_to_rad(1.4),tweenspeedclose)
			bottween.tween_property(pivot_2,"rotation",deg_to_rad(-1.4),tweenspeedclose)
	debounce = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().Previousbranch == null:return
	Hovered.append(area.get_parent())
	hovercheck()

func _on_area_2d_area_exited(area: Area2D) -> void:
	area.get_parent().unhovered()
	Hovered.erase(area.get_parent())
	hovercheck()

func hovercheck():
	if Hovered.size()>0:
		for i:Branch in Hovered:
			i.unhovered()
		Hovered[0].hovered()
