extends Node2D
class_name InputScreen

@export var input_field: TextEdit

func clear():
	input_field.clear()

func get_text():
	return input_field.text
