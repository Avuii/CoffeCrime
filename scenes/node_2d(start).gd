extends Node2D

@onready var play_button = $Control/Play
@onready var exit_button = $Control/Exit  # dodane
@onready var continue_button = $Control/ContinueGame

signal continue_pressed


func _on_play_pressed():
	var game_root = get_node("/root/GameRoot")
	game_root.start_new_game()


func _on_continue_game_pressed() -> void:
	emit_signal("continue_pressed")




func _on_exit_pressed() -> void:
	get_tree().quit()  # zamyka grę
