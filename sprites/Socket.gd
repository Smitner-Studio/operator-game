extends Node2D
class_name Socket

@export var occupied: bool = false

signal received_pulse
signal pulse

func receive_pulse(len: float):
	received_pulse.emit(len)
	
func emit_pulse(len: float):
	pulse.emit(len)
