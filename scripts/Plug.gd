extends Area2D
class_name Plug

var holding: bool = false
var listening: bool = false

signal position_updated
signal pulse

var socket: Socket

func _ready():
	mouse_entered.connect(func(): listening = true)
	mouse_exited.connect(func(): listening = false)

func _input(event: InputEvent) -> void:
	if not listening:
		return
		
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == 1:
			if not holding:
				grab()
			else:
				release()
				
	if event is InputEventMouseMotion and holding:
		update_position(get_global_mouse_position())

func update_position(p: Vector2) -> void:
	global_position = p
	position_updated.emit(position)

func connect_to_socket(s: Socket):
	self.socket = s
	update_position(socket.global_position)
	socket.pulse.connect(propogate_pulse)
	socket.occupied = true
	
func disconnect_from_socket():
	socket.pulse.disconnect(propogate_pulse)
	self.socket.occupied = false
	self.socket = null
	
func propogate_pulse(len: float):
	pulse.emit(len)

func receive_pulse(len: float):
	if socket:
		socket.receive_pulse(len)

func grab():
	if socket:
		disconnect_from_socket()
	holding = true

func release():
	var areas = get_overlapping_areas()
	for x in areas:
		if x is Socket:
			var new_socket = x as Socket
			if !new_socket.occupied:
				connect_to_socket(new_socket)
				break
	holding = false
	
