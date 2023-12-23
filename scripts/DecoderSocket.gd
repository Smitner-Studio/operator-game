extends Node2D

@export var decoder: MorseCodeDecoder
@export var socket: Socket
@export var screen: Screen

func _ready():
	socket.received_pulse.connect(decoder.receive_pulse)
	decoder.decoded.connect(screen.append_text)
