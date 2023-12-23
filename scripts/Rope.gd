
extends Node2D
class_name Rope

@export var ropeLength = 30
@export var constrain = 1.0
@export var gravity = Vector2(0, 9.8)
@export var dampening = 0.9
@export var startPin = true
@export var endPin = true

@onready var line2D: Line2D = $Line2D

var pos: PackedVector2Array
var posPrev: PackedVector2Array
var pointCount: int

func set_start_point(p: Vector2) -> void:
	set_point(0, p)
	
func set_end_point(p: Vector2) ->  void:
	set_point(pointCount - 1, p)
	
func _ready() -> void:
	prepare()
	
func prepare() -> void:
	pointCount = int(ceil(ropeLength / constrain))
	resize_arrays()
	init_position()

func resize_arrays() -> void:
	pos.resize(pointCount)
	posPrev.resize(pointCount)

func init_position() -> void:
	var initialPos = position
	for i in range(pointCount):
		var offset = Vector2(constrain * i, 0)
		pos[i] = initialPos + offset
		posPrev[i] = initialPos + offset
	position = Vector2.ZERO

func _process(delta: float) -> void:
	update_points(delta)
	update_constrain()
	line2D.points = pos

func set_point(index: int, p: Vector2) -> void:
	pos[index] = p
	posPrev[index] = p

func update_points(delta: float) -> void:
	var deltaGravity = gravity * delta
	for i in range(pointCount):
		if should_update_point(i):
			var velocity = (pos[i] - posPrev[i]) * dampening
			posPrev[i] = pos[i]
			pos[i] += velocity + deltaGravity

func should_update_point(index: int) -> bool:
	return (index != 0 and index != pointCount - 1) or \
		   (index == 0 and not startPin) or \
		   (index == pointCount - 1 and not endPin)

func update_constrain() -> void:
	for i in range(pointCount - 1):
		var vec = pos[i + 1] - pos[i]
		var distance = vec.length()
		var difference = constrain - distance
		if distance == 0: continue

		var percent = difference / distance / 2
		if i == 0 and startPin:
			pos[i + 1] += vec * percent * 2
		elif i + 1 == pointCount - 1 and endPin:
			pos[i] -= vec * percent * 2
		else:
			pos[i] -= vec * percent
			pos[i + 1] += vec * percent
