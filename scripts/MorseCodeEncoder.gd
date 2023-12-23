extends Node
class_name MorseCodeEncoder

static func encode_into_buffer(message: String) -> Array:
	var encoded = MorseCodeSystem.encode(message.to_upper())
	return str_to_array(encoded)
	
static func str_to_array(encoded: String) -> Array:
	var message_buffer = []
	for char in encoded:
		message_buffer.append(char)
	return message_buffer
	



