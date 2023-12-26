extends Node2D

@export var message = "HELLO WORLD"
@export var clear_after_transmission = false
@onready var socket: Socket = $Socket
@onready var buffer: MorseCodeBuffer = $MorseCodeBuffer
@onready var button: MorseButton = $MorseButton
@onready var input_screen: InputScreen = $InputScreen

func _ready():
	input_screen.set_text(message)
	
	buffer.pulse.connect(socket.emit_pulse)
	button.pulse.connect(func(x):
		var text = input_screen.get_text()
		var data = MorseCodeSystem.encode_into_array(text)
		buffer.release_custom_buffer(data)
		)
	if clear_after_transmission:
		buffer.outgoing_buffer_transmitted.connect(input_screen.clear)
