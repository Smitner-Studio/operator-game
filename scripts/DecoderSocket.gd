extends Node2D

@export var decoder: MorseCodeDecoder
@export var socket: Socket
@export var label: Label

func _ready():
	socket.received_pulse.connect(decoder.receive_pulse)
	decoder.decoded.connect(func(message): label.text += message)
