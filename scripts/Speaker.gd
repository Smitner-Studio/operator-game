extends Node2D

@export var socket: Socket
@onready var beep_player: BeepPlayer = $BeepPlayer
@onready var pitch_control: ScrollWheel = $PitchScrollWheel
@onready var buffer_control: ScrollWheel = $BufferScrollWheel

func _ready():
	socket.received_pulse.connect(beep_player.beep)
	pitch_control.scroll.connect(beep_player.adjust_pulse_hz)
	buffer_control.scroll.connect(beep_player.cycle_buffer)
