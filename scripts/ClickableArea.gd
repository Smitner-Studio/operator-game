extends Area2D

class_name ClickableArea

var listening = false

signal clicked

var time_pressed = 0
var time_of_press = 0

@onready var sprite := $Sprite2D

func _ready():
	mouse_entered.connect(func(): listening = true)
	mouse_exited.connect(func(): listening = false)

func _input(event: InputEvent) -> void:
	if not listening:
		return
		
	var mouse = event is InputEventMouseButton
	var space = event.is_action("ui_select")
		
	if (mouse and event.is_pressed()) or (space and event.is_pressed())  :
			time_of_press = Time.get_ticks_msec()
			sprite.frame = 1
	if (mouse and event.is_released()) or (space and event.is_released()) :
			time_pressed = Time.get_ticks_msec() - time_of_press
			clicked.emit(time_pressed / 1000.0)
			sprite.frame = 0
	
