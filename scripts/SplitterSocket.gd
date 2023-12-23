extends Node2D


@onready var input: Socket = $Input
@onready var output_1: Socket = $Output
@onready var output_2: Socket = $Output2

func _ready():
	input.received_pulse.connect(output_1.emit_pulse)
	input.received_pulse.connect(output_2.emit_pulse)
