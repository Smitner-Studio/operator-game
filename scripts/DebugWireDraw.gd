@tool

extends Node2D

@onready var wire: Wire = get_parent()
		
func _process(delta):
	if Engine.is_editor_hint():
		if wire.rope:
			queue_redraw()

func _draw():
	if Engine.is_editor_hint():
		var start = (wire.start.global_position) - global_position
		var end = (wire.end.global_position) - global_position
		draw_line(start, end, wire.color, wire.width / 2)
