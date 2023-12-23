extends Node2D

@export var message = "HELLO WORLD"
@onready var socket: Socket = $Socket
@onready var buffer: MorseCodeBuffer = $MorseCodeBuffer
@onready var button: MorseButton = $MorseButton

func _ready():
	buffer.pulse.connect(socket.emit_pulse)
	button.pulse.connect(func(x):
		var data = MorseCodeEncoder.encode_into_buffer(message)
		buffer.release_custom_buffer(data)
		)
