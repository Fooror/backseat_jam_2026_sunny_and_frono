extends Node2D

@onready var area_2d: Area2D = $Sprite/Area2D
@onready var sprite: Sprite2D = $Sprite
@onready var particles: GPUParticles2D = $Sprite/GPUParticles2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use"):
		IsUsing(true)
	if event.is_action_released("use"):
		IsUsing(false)

func _physics_process(delta: float) -> void:
	global_position = get_viewport().get_mouse_position()

func IsUsing(b:bool):
	var tweentime = 0.14
	area_2d.monitoring = b
	particles.emitting = b
	var pailtween = get_tree().create_tween()
	pailtween.set_ease(Tween.EASE_IN_OUT)
	if b == true:
		pailtween.tween_property(self,"rotation",deg_to_rad(-60),tweentime)
	else:
		pailtween.tween_property(self,"rotation",deg_to_rad(0),tweentime)
