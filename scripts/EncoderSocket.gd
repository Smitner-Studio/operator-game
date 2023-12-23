extends Node2D

@export var message = "HELLO WORLD"
@onready var socket: Socket = $Socket
@onready var encoder: MorseCodeEncoder = $MorseCodeEncoder
@onready var button: MorseButton = $MorseButton

func _ready():
	encoder.pulse.connect(socket.emit_pulse)
	button.pulse.connect(func(x):
		encoder.set_buffer(message))
