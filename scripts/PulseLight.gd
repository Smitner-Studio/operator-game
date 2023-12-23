extends Sprite2D

@export var socket: Socket
@export var signal_name: String

@export var color: Color
@export var flash_duration: float = 0.2

func _ready():
	socket.connect(signal_name, flash)

func flash(len: float):
	modulate = color
	await get_tree().create_timer(len).timeout
	modulate = Color.WHITE
