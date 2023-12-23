extends Area2D

class_name ScrollWheel


@export var scroll_spin = 0.5
var listening = false

signal scroll_up
signal scroll_down


func _ready():
	mouse_entered.connect(func(): listening = true)
	mouse_exited.connect(func(): listening = false)

func _input(event: InputEvent) -> void:
	if not listening:
		return
		
	if event.is_action_released("scroll_up"):
		scroll_up.emit()
		$Sprite2D.rotation -= scroll_spin
	if event.is_action_released("scroll_down"):
		scroll_down.emit()
		$Sprite2D.rotation += scroll_spin
	
