extends Node2D




	

func _on_city_cafe_pressed() -> void:
	get_node("/root/GameRoot").show_location("cafe", "YSort", "PlayerSpawn")


func _on_city_home_pressed() -> void:
	get_node("/root/GameRoot").show_location("home", "YSort", "PlayerSpawn")
