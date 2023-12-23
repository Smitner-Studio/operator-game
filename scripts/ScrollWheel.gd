extends Area2D

class_name ScrollWheel


@export var scroll_spin_degrees = 10
@export var scroll_value = 1
var listening = false

signal scroll

@onready var _scroll_spin_rad = deg_to_rad(scroll_spin_degrees)

func _ready():
	mouse_entered.connect(func(): listening = true)
	mouse_exited.connect(func(): listening = false)

func _input(event: InputEvent) -> void:
	if not listening:
		return
		
	if event.is_action_released("scroll_up"):
		scroll.emit(-scroll_value)
		$Sprite2D.rotation -= _scroll_spin_rad
	if event.is_action_released("scroll_down"):
		scroll.emit(scroll_value)
		$Sprite2D.rotation += _scroll_spin_rad
	
