extends Node
class_name SoundhandlerAAAH

var Mastervol:float = 0.4:
	set(val):
		AudioServer.set_bus_volume_db(0,linear_to_db(val))
		Mastervol = val
var Musicvol:float = 0.4:
	set(val):
		AudioServer.set_bus_volume_db(1,linear_to_db(val))
		Musicvol = val
var Soundvol:float = 0.5:
	set(val):
		AudioServer.set_bus_volume_db(2,linear_to_db(val))
		Soundvol = val

const BASTA_DE_NOVO_BOBA = preload("uid://djyrhfea6611t")

const CLICK = preload("uid://dmgokcuo4i0fj")
const POP = preload("uid://d03htn3p2nhsd")
const SLAP = preload("uid://cfy3suwigcjkg")
const BEEF_LOSS = preload("uid://cw8wlvvhn7g82")
const BEEF_VICTORY = preload("uid://bcseiusjcs4r0")
const CLIP_3 = preload("uid://bqki16dv48ga5")
const PICK_2 = preload("uid://b0jo3esoj2q2d")

var Sounds = [CLICK,POP,SLAP,BEEF_LOSS,BEEF_VICTORY,CLIP_3,PICK_2]
enum Soundenum {click,pop,slap,loss,victory,clip,picktool}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.set_bus_volume_db(0,linear_to_db(Mastervol))
	AudioServer.set_bus_volume_db(1,linear_to_db(Musicvol))
	AudioServer.set_bus_volume_db(2,linear_to_db(Soundvol))
	var Playmusic = AudioStreamPlayer.new()
	add_child(Playmusic)
	Playmusic.bus = "Music"
	Playmusic.stream = BASTA_DE_NOVO_BOBA
	Playmusic.volume_db = Musicvol
	Playmusic.autoplay = true
	Playmusic.play(0.0)

func playsoundnopos(sound):
	var Sound = AudioStreamPlayer.new()
	add_child(Sound)
	Sound.bus = "SFX"
	Sound.stream = Sounds[sound]
	Sound.volume_db = Soundvol
	Sound.autoplay = true
	Sound.play(0.0)
	

func playsound(sound,position:Vector2):
	var Sound = AudioStreamPlayer2D.new()
	add_child(Sound)
	Sound.global_position = position
	Sound.bus = "SFX"
	Sound.stream = Sounds[sound]
	Sound.volume_db = Soundvol
	Sound.autoplay = true
	Sound.play(0.0)
