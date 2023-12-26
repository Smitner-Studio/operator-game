extends Node2D

@onready var decoder: MorseCodeDecoder = $Decoder
@onready var socket: Socket = $Socket
@onready var screen: Screen = $Screen

enum ScreenUpdateMode {
	LETTER, WORD, MESSAGE
}
@export var screen_update_mode := ScreenUpdateMode.WORD

func _ready():
	socket.received_pulse.connect(decoder.receive_pulse)

	match screen_update_mode:
		ScreenUpdateMode.MESSAGE:
			decoder.message_received.connect(append_and_clear)
		ScreenUpdateMode.WORD:
			decoder.word_received.connect(append_and_clear)
		ScreenUpdateMode.LETTER:
			decoder.letter_received.connect(append_and_clear)

func append_and_clear():
		var buffer = decoder.get_buffer_contents()
		print(MorseCodeSystem.array_to_str(buffer))
		var message = MorseCodeSystem.decode_from_array(buffer)
		decoder.clear()
		screen.append_text(message)
		print(message)
