extends CanvasLayer

@onready var text_edit: LineEdit = $TextEdit
@onready var line_edit: LineEdit = $LineEdit

@onready var message: Timer = $Message
@onready var newuser: Timer = $Newuser

var OnorOff:bool = false

var Usernametable = [
	"FootSniffer",
	"Beefmaster123",
	"Caelum@starmail.com",
	"John",
	"TheWormiestWormthatWormed",
	"Poop",
	"Toesuccker",
	"PestifariousBug",
]

var Activeusers = []

const Messages = [
	"flower",
	"flower",
	"leaf",
	"leaf",
	"leaf",
	"up",
	"down",
	"left",
	"right",
]

func  _ready() -> void:
	hide()

func _on_button_pressed() -> void:
	Twitchhandle.MessageRecieved.emit(line_edit.text,text_edit.text)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open debug"):
		if visible == true: hide()
		else: show()

func _unhandled_key_input(event: InputEvent) -> void:
	if text_edit.has_focus():
		get_viewport().set_input_as_handled()

func _on_button_2_pressed() -> void:
	if OnorOff == false:
		OnorOff = true
		print ("true")
		message.start()
		newuser.start()
	else:
		OnorOff = false
		print ("false")
		message.stop()
		newuser.stop()

func newusersend():
	if Usernametable.size() <= 0:return
	var whichuser
	whichuser = randi_range(0,Usernametable.size()-1)
	Activeusers.append(Usernametable[whichuser])
	Usernametable.remove_at(whichuser)
	Twitchhandle.MessageRecieved.emit(Activeusers[randi_range(0,Activeusers.size()-1)],"sprout")

func randommessage():
	if Activeusers.size() > 0:
		Twitchhandle.MessageRecieved.emit(Activeusers[randi_range(0,Activeusers.size()-1)],Messages[randi_range(0,Messages.size()-1)])

func _on_message_timeout() -> void:
	randommessage()

func _on_newuser_timeout() -> void:
	newusersend()


func _on_button_3_pressed() -> void:
	Usernametable.append_array(Activeusers)
	Activeusers = []
