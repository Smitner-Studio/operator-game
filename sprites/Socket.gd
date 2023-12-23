extends Node2D
class_name Socket

@export var occupied: bool = false
@export var bound_socket: Socket

signal received_pulse
signal pulse

func _ready():
	if bound_socket:
		bound_socket.pulse.connect(receive_pulse)
		bound_socket.received_pulse.connect(emit_pulse)

		
func receive_pulse(len: float):
	received_pulse.emit(len)
	
func emit_pulse(len: float):
	pulse.emit(len)
