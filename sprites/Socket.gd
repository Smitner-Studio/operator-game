extends Node2D
class_name Socket

@export var occupied: bool = false

enum SignalDirection {
	Send, Receive, Both
}
@export var primary_signal_direction: SignalDirection = SignalDirection.Both
@onready var sprite := $Sprite2D


signal received_pulse
signal pulse

func _ready():
	match primary_signal_direction:
		SignalDirection.Send:
			sprite.modulate = Color.LIGHT_BLUE
		SignalDirection.Receive:
			sprite.modulate = Color.LIGHT_CORAL
		SignalDirection.Both:
			pass

func receive_pulse(len: float):
	received_pulse.emit(len)
	
func emit_pulse(len: float):
	pulse.emit(len)
