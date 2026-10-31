extends Node
class_name Roundhandler

signal Timerstarted(time:float)

@export var Currentround:int = 1
@export var Bestround:int = 0

@export var Roundtime:float = 240.0

const Gamelevel:String = "res://Gamelevel/game_level.tscn"
const Gamemenu:String = "res://Menu/menu.tscn"
const Gameover:String = "uid://cbq0m6rew4p2j"

@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var label: Label = $CanvasLayer/Roundsign/TextureRect/Label
@onready var scene_transition: Control = $CanvasLayer/SceneTransition

@onready var round: Timer = $Round
@onready var settings: Settingswindow = $Menu/Settings

func _ready() -> void:
	scene_transition.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("settingsmenu"):
		if settings.visible == true:
			settings.hideandunpause()
		else: settings.showandpause()

func NewRound():
	get_tree().change_scene_to_file(Gamelevel)
	await ToggleTransitionscreen(false)
	label.text = ("ROUND "+str(Currentround))
	animation_player.play("Sign IN")
	await get_tree().create_timer(1.5).timeout
	
	animation_player.play("Sign WOBBLE")
	var Fruitamm = int(pow(Currentround,1.8)+4.0)
	label.text = ("You must get "+str(ceil(Fruitamm))+" fruits.")
	await get_tree().create_timer(1.7).timeout
	
	animation_player.play("Sign WOBBLE")
	label.text = "Ready?"
	await get_tree().create_timer(1).timeout
	
	animation_player.play("Sign WOBBLE")
	label.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	
	animation_player.play("Sign OUT")
	get_tree().paused = false
	round.start(Roundtime)
	Timerstarted.emit(Roundtime)

func Victory():
	Soundhandler.playsoundnopos(Soundhandler.Soundenum.victory)
	get_tree().paused = true
	Currentround +=1
	if Currentround > Bestround:
		Bestround = Currentround
	await Displaysign("ROUND COMPLETE!",2.0)
	await ToggleTransitionscreen(true)
	NewRound()

func Displaysign(text:String,time:float):
	label.text = text
	animation_player.play("Sign IN")
	await animation_player.animation_finished
	await get_tree().create_timer(time).timeout
	animation_player.play("Sign OUT")
	await animation_player.animation_finished

func GameOver():
	Soundhandler.playsoundnopos(Soundhandler.Soundenum.loss)
	get_tree().paused = true
	await Displaysign("TIME'S UP!",2.0)
	await ToggleTransitionscreen(true)
	ToEndscreen()

func ToEndscreen():
	get_tree().change_scene_to_file(Gameover)
	await ToggleTransitionscreen(false)
	get_tree().paused = false

func BackToMenu():
	await ToggleTransitionscreen(true)
	get_tree().change_scene_to_file(Gamemenu)
	await ToggleTransitionscreen(false)
	get_tree().paused = false

func NewGame():
	get_tree().paused = true
	Currentround = 1
	await get_tree().create_timer(0.5)
	await ToggleTransitionscreen(true)
	NewRound()

func ToggleTransitionscreen(b:bool):
	if b == true:
		animation_player.play("Transition IN")
		scene_transition.show()
		await animation_player.animation_finished
	else:
		await get_tree().create_timer(0.4).timeout
		animation_player.play_backwards("Transition IN")
		await animation_player.animation_finished
		scene_transition.hide()


func _on_round_timeout() -> void:
	GameOver()
