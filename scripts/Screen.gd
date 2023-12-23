extends Node2D
class_name Screen

@export var label: Label

func append_text(text: String):
	label.text += text

func clear():
	label.text = ""
