extends Node2D

func _on_response_selected(response):
	if response.text == "Yes":
		get_tree().change_scene_to_file("res://scenes/ending.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ending.tscn")  # np. też kończysz, ale potem pytasz „Kto porwał?"
