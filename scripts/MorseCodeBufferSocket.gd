extends Node2D
class_name MorseCodeBufferSocket

@onready var input_socket := $Input
@onready var save_letter := $Save
@onready var output_socket := $Output
@onready var screen := $Screen
@onready var buffer := $MorseCodeBuffer
@onready var send_button := $Button


func _ready():
	input_socket.received_pulse.connect(buffer.receive_pulse)
	save_letter.received_pulse.connect(func(x): buffer.append_letter_separator())
	send_button.pulse.connect(
		func(x): buffer.release_incoming_buffer())
	
	
	buffer.pulse.connect(output_socket.emit_pulse)
	buffer.letter_stored.connect(
		func(data):
			screen.clear()
			screen.append_text(" ".join(data))
			
	)
	buffer.incoming_buffer_cleared.connect(screen.clear)
