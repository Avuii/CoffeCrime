extends Node2D

@onready var text_label = $Control/Panel/Label

func show_message(text: String, duration: float = 3.0):
	text_label.text = text
	show()
	await get_tree().create_timer(duration).timeout
	hide()
	queue_free()
