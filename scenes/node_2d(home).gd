extends Node2D
@onready var homecity := $HomeCity



func _on_home_city_pressed():
	get_node("/root/GameRoot").show_location("city", "YSortCity", "PlayerSpawn1")

func _on_bed_pressed() -> void:
	var gameroot = get_parent()
	gameroot.next_day()
