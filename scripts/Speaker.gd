extends Node2D

class_name Speaker

@onready var beep_player: BeepPlayer = $BeepPlayer
@onready var pitch_control: ScrollWheel = $PitchScrollWheel
@onready var buffer_control: ScrollWheel = $BufferScrollWheel

func _ready():
	pitch_control.scroll.connect(beep_player.adjust_pulse_hz)
	buffer_control.scroll.connect(beep_player.cycle_buffer)

func beep(len: float):
	beep_player.beep(len)
