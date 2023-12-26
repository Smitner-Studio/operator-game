extends Node2D

var sockets: Array[Socket]

func _ready():
	
	for child in get_children():
		if child is Socket:
			sockets.append(child)
	
	for child in get_children():
		if not child is Socket: continue
		var receiver = child as Socket
		for emitter in sockets:
			if emitter == receiver: continue
			receiver.received_pulse.connect(emitter.emit_pulse)
		
