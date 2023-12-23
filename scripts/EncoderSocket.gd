extends Node2D

@export var message = "HELLO WORLD"
@onready var socket: Socket = $Socket
@onready var buffer: MorseCodeBuffer = $MorseCodeBuffer
@onready var button: MorseButton = $MorseButton
@onready var input_screen: InputScreen = $InputScreen

func _ready():
	buffer.pulse.connect(socket.emit_pulse)
	button.pulse.connect(func(x):
		var text = input_screen.get_text()
		var data = MorseCodeEncoder.encode_into_buffer(text)
		buffer.release_custom_buffer(data)
		)
	buffer.outgoing_buffer_transmitted.connect(input_screen.clear)
