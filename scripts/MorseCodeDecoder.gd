extends Node

class_name MorseCodeDecoder

signal decoded

var pulse_buffer = []
var last_pulse_received_time = 0

signal letter_received
signal word_received
signal message_received
signal buffer_cleared

func receive_pulse(duration):
	# Record the time when the pulse is received
	var current_time = Time.get_ticks_msec()
	last_pulse_received_time = current_time
	
	# Determine if the pulse is a dot or a dash based on its duration
	if duration <= MorseCodeSystem.short_pulse_duration:
		pulse_buffer.append(MorseCodeSystem.dot)
	elif duration > MorseCodeSystem.short_pulse_duration:
		pulse_buffer.append(MorseCodeSystem.dash)

func _process(delta):
	var current_time = Time.get_ticks_msec()
	if (pulse_buffer.is_empty() or
		current_time == last_pulse_received_time):
		return
		
	var pause_duration = (current_time - last_pulse_received_time) / 1000.0
	if (
		pause_duration >= MorseCodeSystem.message_pause_duration
		and is_last_separator(MorseCodeSystem.word_break)):
			message_received.emit()
	elif (
		pause_duration >= MorseCodeSystem.word_pause_duration
		and not is_last_separator(MorseCodeSystem.word_break)):
			append_separator(MorseCodeSystem.word_break)
			word_received.emit()
	elif (
		pause_duration >= MorseCodeSystem.letter_pause_duration and
		pause_duration < MorseCodeSystem.word_pause_duration and
		not is_last_separator(MorseCodeSystem.letter_break)):
			append_separator(MorseCodeSystem.letter_break)
			letter_received.emit()

func clear():
	pulse_buffer.clear()
	buffer_cleared.emit()
	
func get_buffer_contents():
	return pulse_buffer.duplicate()

func append_separator(separator: String):
	pulse_buffer.append(separator)

func is_last_separator(separator: String) -> bool:
	return not pulse_buffer.is_empty() and pulse_buffer.back() == separator
