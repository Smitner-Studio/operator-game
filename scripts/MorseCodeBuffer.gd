extends Node

class_name MorseCodeBuffer

signal pulse
signal letter_stored
signal incoming_buffer_cleared

var incoming_buffer = []
var outgoing_buffer = []
var time_to_next = 0

func receive_pulse(duration):
	if duration <= MorseCodeSystem.short_pulse_duration:
		incoming_buffer.append(".")
	elif duration > MorseCodeSystem.short_pulse_duration:
		incoming_buffer.append("-")

func append_letter_separator():
	if not is_last_separator(MorseCodeSystem.letter_break):
		append_separator(MorseCodeSystem.letter_break)
		letter_stored.emit(incoming_buffer)

func clear():
	incoming_buffer.clear()
	incoming_buffer_cleared.emit()
	
func release_incoming_buffer():
	outgoing_buffer = incoming_buffer.duplicate()
	outgoing_buffer.reverse()
	clear()
	
func release_custom_buffer(buffer: Array):
	outgoing_buffer = buffer
	outgoing_buffer.reverse()
	
func append_separator(separator: String):
	incoming_buffer.append(separator)

func is_last_separator(separator: String) -> bool:
	return not incoming_buffer.is_empty() and incoming_buffer.back() == separator

func _process(delta):
	var current = Time.get_ticks_msec()
	if current > time_to_next and !outgoing_buffer.is_empty():
		do_next()

func do_next():
	var outgoing_next_char = outgoing_buffer.pop_back()
	var t = MorseCodeSystem.long_pulse_duration
	match outgoing_next_char:
		MorseCodeSystem.dot:
			emit_pulse(MorseCodeSystem.short_pulse_duration)
		MorseCodeSystem.dash:
			emit_pulse(MorseCodeSystem.long_pulse_duration)
		MorseCodeSystem.letter_break:
			t  = MorseCodeSystem.letter_pause_duration
		MorseCodeSystem.word_break:
			t = MorseCodeSystem.word_pause_duration
	time_to_next = Time.get_ticks_msec() + (t * 1000)

func emit_pulse(len: float):
	print(len)
	pulse.emit(len)  
