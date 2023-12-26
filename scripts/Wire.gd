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

# Recursion Detection
const recursion_limit = 10
class InfiniteRecursionDetection:
	var recursion_iteration = 0
	var last_pulse_time = 0

	func reset():
		recursion_iteration = 0
		
	func detected(): return recursion_iteration >= recursion_limit

var start_rd := InfiniteRecursionDetection.new()
var end_rd := InfiniteRecursionDetection.new()
func is_recursion_detected(): return start_rd.detected() or end_rd.detected()

func _ready():
	
	start.position_updated.connect(rope.set_start_point)
	end.position_updated.connect(rope.set_end_point)
	
	set_wire_color(color)
	rope.line2D.width = width
	rope.set_start_point(start.position)
	rope.set_end_point(end.position)
	
	
	start.pulse.connect(func(len):
		bridge_pulse(len, end.receive_pulse, end_rd))
		
	end.pulse.connect(func(len):
		bridge_pulse(len, start.receive_pulse, start_rd))
	
	connect_to_underlying_sockets()

func connect_to_underlying_sockets():
	await get_tree().create_timer(0.5).timeout
	start.release()
	end.release()
	
func bridge_pulse(
	len: float,
	fn: Callable,
	rd: InfiniteRecursionDetection):
		
	# Detect how many times this has been called in the current frame
	# and "burn" the wire when it exceeds a pre-defined limit
	# to prevent infinite recursion
	var current = Time.get_ticks_msec()
	if (current == rd.last_pulse_time):
		rd.recursion_iteration += 1
	
	if is_recursion_detected():
		burn_wire()
	else:
		rd.last_pulse_time = current
		fn.call(len)
	

func _process(delta):
	if start.holding:
		rope.line2D.width_curve = holdingStartCurve
		reset_plug_scale()
		scale_up_plug(start)
		revive_wire()
	elif end.holding:
		rope.line2D.width_curve = holdingEndCurve
		reset_plug_scale()
		scale_up_plug(end)
		revive_wire()
	else:
		rope.line2D.width_curve = notHoldingCurve
		reset_plug_scale()

func burn_wire():
	var burnt_color = Color.BLACK
	set_wire_color(burnt_color)
	start.modulate = burnt_color
	end.modulate = burnt_color
	print("sizzle")
	
func revive_wire():
	start_rd.reset()
	end_rd.reset()
	
	set_wire_color(color)
	start.modulate = Color.WHITE
	end.modulate = Color.WHITE

func set_wire_color(color: Color):
	rope.line2D.default_color = color

func reset_plug_scale():
	end.scale = Vector2.ONE 
	start.scale = Vector2.ONE
	
func scale_up_plug(plug: Plug):
	plug.scale = Vector2.ONE * plug_scalar
