extends Node2D

@onready var socket: Socket = $Input
@onready var speaker: Speaker = $Speaker

func _ready():
	socket.received_pulse.connect(speaker.beep)
