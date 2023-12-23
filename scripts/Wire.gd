extends Node2D

class_name Wire

@export var rope: Rope
@export var start: Plug
@export var end: Plug

@export_group("Visuals")
@export var color: Color = Color.WHITE
@export var width: int = 30
@export var plug_scalar: float = 1.2

@export var holdingStartCurve: Curve
@export var holdingEndCurve: Curve
@export var notHoldingCurve: Curve

func _ready():
	start.position_updated.connect(rope.set_start_point)
	end.position_updated.connect(rope.set_end_point)
	
	rope.line2D.default_color = color
	rope.line2D.width = width
	rope.set_start_point(start.position)
	rope.set_end_point(end.position)
	
	start.pulse.connect(end.receive_pulse)
	end.pulse.connect(start.receive_pulse)
	
	connect_to_underlying_sockets()

func connect_to_underlying_sockets():
	await get_tree().create_timer(0.5).timeout
	start.release()
	end.release()

func _process(delta):
	if start.holding:
		rope.line2D.width_curve = holdingStartCurve
		reset_plug_scale()
		scale_up_plug(start)
	elif end.holding:
		rope.line2D.width_curve = holdingEndCurve
		reset_plug_scale()
		scale_up_plug(end)
	else:
		rope.line2D.width_curve = notHoldingCurve
		reset_plug_scale()

func reset_plug_scale():
	end.scale = Vector2.ONE 
	start.scale = Vector2.ONE
	
func scale_up_plug(plug: Plug):
	plug.scale = Vector2.ONE * plug_scalar
