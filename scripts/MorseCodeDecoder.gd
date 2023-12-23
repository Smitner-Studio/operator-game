extends Node

class_name MorseCodeDecoder

signal decoded

var pulse_buffer = []
var last_pulse_received_time = 0

func receive_pulse(duration):
	# Record the time when the pulse is received
	var current_time = Time.get_ticks_msec()
	var pause_duration = current_time - last_pulse_received_time
	last_pulse_received_time = current_time
	var pause_in_seconds = pause_duration * 0.001

	if pause_in_seconds >= MorseCodeSystem.word_pause_duration and not is_last_separator(MorseCodeSystem.word_break):
		append_separator(MorseCodeSystem.word_break)
		print(name + ": word received")
	if pause_in_seconds >= MorseCodeSystem.letter_pause_duration and not is_last_separator(MorseCodeSystem.letter_break):
		append_separator(MorseCodeSystem.letter_break)
		print(name + ": letter received")
		decode_and_clear_buffer()
	# Determine if the pulse is a dot or a dash based on its duration
	if duration <= MorseCodeSystem.short_pulse_duration:
		pulse_buffer.append(".")
	elif duration > MorseCodeSystem.short_pulse_duration:
		pulse_buffer.append("-")


func decode_and_clear_buffer():
	var message = MorseCodeSystem.decode(str_from_pulse_buffer())
	pulse_buffer.clear()
	decoded.emit(message)

func str_from_pulse_buffer():
	return ''.join(pulse_buffer)

func append_separator(separator: String):
	pulse_buffer.append(separator)

func is_last_separator(separator: String) -> bool:
	return not pulse_buffer.is_empty() and pulse_buffer.back() == separator
