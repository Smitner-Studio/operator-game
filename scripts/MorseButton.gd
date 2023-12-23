extends Area2D

class_name MorseButton

var listening = false

signal pulse

var _pressed = false
var pressed:
	get:
		return _pressed
	set(x):
		_pressed = x
		if (x):
			sprite.frame = 1
		else:
			sprite.frame = 0
	
var time_of_press = 0

@onready var sprite := $Sprite2D

func _ready():
	mouse_entered.connect(func(): listening = true)
	mouse_exited.connect(func(): listening = false)

func _input(event: InputEvent) -> void:
	if not listening:
		return
			
	if event.is_action_pressed("click"):
		time_of_press = Time.get_ticks_msec()
		pressed = true
	if event.is_action_released("click") and pressed:
		var time_pressed = (Time.get_ticks_msec() - time_of_press) / 1000.0
		release_press(time_pressed)
	
func _process(delta):
	var current_time = Time.get_ticks_msec()
	var time_pressed = (Time.get_ticks_msec() - time_of_press) / 1000.0
	if pressed and time_pressed >= MorseCodeSystem.long_pulse_duration:
		release_press(time_pressed)
		
func release_press(time_pressed: float):
	pressed = false
	emit_normalized_pulse(time_pressed)

func emit_normalized_pulse(len: float):
	if len < MorseCodeSystem.short_pulse_duration:
		pulse.emit(MorseCodeSystem.short_pulse_duration)
		print(name + ': .')
	else:
		pulse.emit(MorseCodeSystem.long_pulse_duration)
		print(name + ': -')
