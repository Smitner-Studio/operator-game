extends Node2D

@onready var click_area: ClickableArea = $ClickableArea

signal pulse

func _ready():
	click_area.clicked.connect(emit_normalized_pulse)

func emit_normalized_pulse(len: float):
	print(len)
	if len < MorseCodeSystem.short_pulse_duration:
		pulse.emit(MorseCodeSystem.short_pulse_duration)
		print(name + ': .')
	else:
		pulse.emit(MorseCodeSystem.long_pulse_duration)
		print(name + ': -')
