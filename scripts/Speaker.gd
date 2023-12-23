extends Node2D

@export var socket: Socket
@onready var beep_player: BeepPlayer = $BeepPlayer
@onready var scroll_wheel: ScrollWheel = $ScrollWheel

func _ready():
	socket.received_pulse.connect(beep_player.beep)
	scroll_wheel.scroll_down.connect(func(): adjust_pulse_hz(-100))
	scroll_wheel.scroll_up.connect(func():adjust_pulse_hz(100))
	

func adjust_pulse_hz(amount: float):
	beep_player.pulse_hz += amount
	print(beep_player.pulse_hz)
