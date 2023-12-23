extends Node

class_name RegularSignal

@export var output_socket: Socket

var t = 0
var p = 0

func _ready():
	t = randf()

func _process(delta):
	t+=delta
	p = sin(t)
	if (p > 0.9):
		if output_socket: output_socket.emit_pulse(0.5)
		t = 0
