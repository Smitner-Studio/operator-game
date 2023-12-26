extends Node

class_name MorseCodeSystem

static var morse_code = {
	"A": ".-", "B": "-...", "C": "-.-.", "D": "-..", "E": ".",
	"F": "..-.", "G": "--.", "H": "....", "I": "..", "J": ".---",
	"K": "-.-", "L": ".-..", "M": "--", "N": "-.", "O": "---",
	"P": ".--.", "Q": "--.-", "R": ".-.", "S": "...", "T": "-",
	"U": "..-", "V": "...-", "W": ".--", "X": "-..-", "Y": "-.--",
	"Z": "--..",
	
	"1": ".----", "2": "..---", "3": "...--",
	"4": "....-", "5": ".....", "6": "-....",
	"7": "--...", "8": "---..", "9": "----.",
	"0": "-----"
}

static var inv_morse_code = MorseCodeSystem.invert_dictionary(morse_code)

# Duration of a short and long pulse (dot and dash)
static var short_pulse_duration = 0.04
static var long_pulse_duration = short_pulse_duration * 3

static var letter_pause_duration = long_pulse_duration * 1.5
# If it's a space, wait a bit longer (7 units - standard in Morse code)
static var word_pause_duration = letter_pause_duration * 2
static var message_pause_duration = word_pause_duration * 4


# Symbols for encoding
static var dot = "."
static var dash = "-"
static var letter_break = " "
static var word_break = "/"

# Encode a text message into Morse code
static func encode(message: String) -> String:
	var encoded = ""
	message = message.to_upper()  # Ensure the message is in uppercase
	for char in message:
		if char in morse_code:
			# Translate each character to Morse and add to the encoded string
			encoded += morse_code[char] + letter_break
		elif char == " ":
			# Add a word break for spaces
			encoded += word_break
	return encoded
	
static func encode_into_array(message: String) -> Array:
	var encoded = encode(message)
	return str_to_array(encoded)

# Decode Morse code back into text
static func decode(morse_message: String) -> String:
	var decoded_message = ""
	var morse_characters = morse_message.split(word_break)  # Split at word breaks

	for morse_word in morse_characters:
		var letters = morse_word.split(letter_break)  # Split at letter breaks
		for morse_letter in letters:
			if morse_letter != "":
				decoded_message += inv_morse_code.get(morse_letter, "?") # Decode each Morse letter
		decoded_message += " "  # Add a space after each word

	return decoded_message
	
static func decode_from_array(buffer: Array) -> String:
	var message =  ''.join(buffer)
	return decode(message)
	
# Function to invert a dictionary (swap its keys and values)
static func invert_dictionary(dict : Dictionary) -> Dictionary:
	var inverted_dict = {}
	for key in dict.keys():
		# Ensure the value doesn't already exist as a key in the inverted dictionary
		if not dict[key] in inverted_dict:
			inverted_dict[dict[key]] = key
		else:
			printerr("Duplicate value found when attempting to invert dictionary: ", dict[key])
	return inverted_dict
	
static func str_to_array(encoded: String) -> Array:
	var message_buffer = []
	for char in encoded:
		message_buffer.append(char)
	return message_buffer
	

# Example usage
static func test():
	var message = "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG 1234567890"
	var encoded = MorseCodeSystem.encode(message)
	print("Encoded: ", encoded)
	var decoded = MorseCodeSystem.decode(encoded)
	print("Decoded: ", decoded)
