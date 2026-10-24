extends Node

signal ChatConnected(channelname:String)

signal MessageRecieved(user:String,message:String)

var TwitchChat: VSTChat

func Connect_chat(channelname:String):
	TwitchChat = VSTChat.new()
	add_child(TwitchChat)
	TwitchChat.login_anon(channelname)
	ChatConnected.emit(channelname)
	TwitchChat.OnMessage.connect(Emit_Chatter_and_Message)

func Emit_Chatter_and_Message(chatter: VSTChatter):
	MessageRecieved.emit(chatter.tags.display_name,chatter.message)
