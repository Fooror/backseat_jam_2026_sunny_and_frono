extends Control

@onready var texture_rect: TextureRect = $TextureRect
@onready var needle: TextureRect = $Needle
@onready var time: Label = $Time

const Modcolor:Color = Color(1.0, 0.5, 0.5, 1.0)

const Startingrotation:float = -90.2
const Endrotation:float = 95.5

func _ready() -> void:
	needle.rotation = deg_to_rad(Startingrotation)
	Rounds.Timerstarted.connect(starttimer)

func _process(delta: float) -> void:
	if Rounds.round.time_left <60:
		time.modulate
	time.text = timestring()

func starttimer(time:float):
	var timertween = get_tree().create_tween()
	timertween.tween_property(needle,"rotation",deg_to_rad(Endrotation),time)
	var timestringminute

func timestring():
	var time = floor(Rounds.round.time_left)
	var minute = floori(time/60)
	var second = floori(time - (minute*60))
	if second <10:
		second = "0"+str(second)
	else: second = str(second)
	return str(minute)+":"+second
